Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbaGXMCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:02:25 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60980 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbaGXMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:02:24 -0400
Date: Thu, 24 Jul 2014 08:02:22 -0400 (EDT)
From: Ulrich Obergfell <uobergfe@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dzickus@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Message-ID: <300049235.17260559.1406203342695.JavaMail.zimbra@redhat.com>
In-Reply-To: <53D0F1EB.9080504@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com> <53D0E3F3.6050206@redhat.com> <1140033921.17233579.1406200685037.JavaMail.zimbra@redhat.com> <53D0ED70.4070800@redhat.com> <146661093.17248776.1406202294303.JavaMail.zimbra@redhat.com> <53D0F1EB.9080504@redhat.com>
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.7]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF22 (Linux)/8.0.6_GA_5922)
Thread-Topic: watchdog: control hard lockup detection default
Thread-Index: SnBZXdjLe+GXu/dg7OcqqJ3yorsD8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>----- Original Message -----
>From: "Paolo Bonzini" <pbonzini@redhat.com>
>To: "Ulrich Obergfell" <uobergfe@redhat.com>
>Cc: "Andrew Jones" <drjones@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dzickus@redhat.com, akpm@linux-foundation.org, >mingo@redhat.com
>Sent: Thursday, July 24, 2014 1:45:47 PM
>Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
>
>Il 24/07/2014 13:44, Ulrich Obergfell ha scritto:
>> > But this means that it is not possible to re-enable softlockup detection
>> > only.  I think that should be the effect of echo 0 + echo 1, if
>> > hardlockup detection was disabled by either the command line or patch 3.
>>
>> The idea was to give the user two options to override the effect of patch 3/3.
>> Either via the kernel command line ('nmi_watchdog=') at boot time or via /proc
>> ('echo 0' + 'echo 1') when the system is up and running.
>
> I think the kernel command line is enough; another alternative is to
> split the nmi_watchdog /proc entry in two.
>
> Paolo

The current behaviour (without the patch) already allows a user to disable
NMI watchdog at boot time ('nmi_watchdog=0') and enable it explicitly when
the system is up and running ('echo 0' + 'echo 1'). I think it would be
more consistent with this behaviour and more intuitive if we would give
the user the option to override the effect of patch 3/3 via /proc. By
'intuitive' I mean that the user says: 'I _want_ this to be enabled'.

Regards,

Uli

