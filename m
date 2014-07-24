Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaGXLpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbaGXLpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:45:53 -0400
Message-ID: <53D0F1EB.9080504@redhat.com>
Date: Thu, 24 Jul 2014 13:45:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ulrich Obergfell <uobergfe@redhat.com>
CC: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dzickus@redhat.com, akpm@linux-foundation.org,
        mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com> <53D0E3F3.6050206@redhat.com> <1140033921.17233579.1406200685037.JavaMail.zimbra@redhat.com> <53D0ED70.4070800@redhat.com> <146661093.17248776.1406202294303.JavaMail.zimbra@redhat.com>
In-Reply-To: <146661093.17248776.1406202294303.JavaMail.zimbra@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 13:44, Ulrich Obergfell ha scritto:
> > But this means that it is not possible to re-enable softlockup detection
> > only.  I think that should be the effect of echo 0 + echo 1, if
> > hardlockup detection was disabled by either the command line or patch 3.
>
> The idea was to give the user two options to override the effect of patch 3/3.
> Either via the kernel command line ('nmi_watchdog=') at boot time or via /proc
> ('echo 0' + 'echo 1') when the system is up and running.

I think the kernel command line is enough; another alternative is to
split the nmi_watchdog /proc entry in two.

Paolo
