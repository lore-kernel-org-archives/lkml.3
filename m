Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3HORCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:02:09 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52199 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab3HORCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:02:07 -0400
Message-ID: <520D0953.2020403@interlog.com>
Date: Thu, 15 Aug 2013 13:01:07 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: David Milburn <dmilburn@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>,
        Costa Sapuntzakis <costa@purestorage.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH v2] [SCSI] sg: Fix user memory corruption when SG_IO is
 interrupted by a signal
References: <1375746189.18481.23.camel@dabdike.int.hansenpartnership.com> <1375750501-21902-1-git-send-email-roland@kernel.org> <52025BE3.5020002@redhat.com> <CAL1RGDVktaz4Y4_bB+uTzjk0R1+RgwF7DNuZ_+zvpLvH90oTQA@mail.gmail.com>
In-Reply-To: <CAL1RGDVktaz4Y4_bB+uTzjk0R1+RgwF7DNuZ_+zvpLvH90oTQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-15 12:45 PM, Roland Dreier wrote:
> Jens / James, do you guys plan to send this to Linus for 3.11?
> Triggering this bug is a bit esoteric but the impact is pretty nasty
> (corrupting an unrelated process).

The patch is fine with me. Even though the sg driver is
named in the patch title, I note that the v2 patch is
only against the block layer. Hence it does not need an
ack from me.

Doug Gilbert


