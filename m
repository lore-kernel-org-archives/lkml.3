Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaG3OQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbaG3OQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:16:45 -0400
Message-ID: <53D8FE46.2000100@redhat.com>
Date: Wed, 30 Jul 2014 16:16:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>, Andrew Jones <drjones@redhat.com>
CC: Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com
Subject: Re: [PATCH 2/3] watchdog: control hard lockup detection default
References: <1406196811-5384-1-git-send-email-drjones@redhat.com> <1406196811-5384-3-git-send-email-drjones@redhat.com> <615371508.17867577.1406277175913.JavaMail.zimbra@redhat.com> <20140725112510.GA3456@hawk.usersys.redhat.com> <20140730134342.GA7959@redhat.com>
In-Reply-To: <20140730134342.GA7959@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/07/2014 15:43, Don Zickus ha scritto:
>> > Nice catch. Looks like this will need a v2. Paolo, do we have a
>> > consensus on the proc echoing? Or should that be revisited in the v2 as
>> > well?
> As discussed privately, how about something like this to handle that case:
> (applied on top of these patches)

Don, what do you think about proc?

My opinion is still what I mentioned earlier in the thread, i.e. that if
the file says "1", writing "0" and then "1" should not constitute a
change WRT to the initial state.

Paolo
