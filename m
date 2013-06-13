Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3FMQ3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:29:10 -0400
Received: from mail.tpi.com ([70.99.223.143]:1441 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FMQ3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:29:09 -0400
X-Greylist: delayed 1732 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 12:29:09 EDT
Message-ID: <51B9EC8D.7040702@canonical.com>
Date: Thu, 13 Jun 2013 10:00:13 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tommi Rantala <tt.rantala@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH linux-next v2] DM RAID: validate_raid_redundancy: Silence
 uninitialized variable warning
References: <20130221131931.GA29577@agk-dp.fab.redhat.com> <1361458226-8142-1-git-send-email-tim.gardner@canonical.com> <CA+ydwtq_THgL87ESb4Z4T8pMhZUQiAX_9qac2agPwHABGEjuRA@mail.gmail.com>
In-Reply-To: <CA+ydwtq_THgL87ESb4Z4T8pMhZUQiAX_9qac2agPwHABGEjuRA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 09:30 AM, Tommi Rantala wrote:
> 2013/2/21 Tim Gardner <tim.gardner@canonical.com>:
>> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
>> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here
> 
> Hello, is this patch getting merged? I'm also seeing this exact same
> compiler warning in my mainline builds.
> 
> Tommi
> 

Dunno. I haven't hassled anyone because it _is_ just a warning.
-- 
Tim Gardner tim.gardner@canonical.com
