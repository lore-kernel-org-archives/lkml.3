Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3EMQe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3EMQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:34:26 -0400
Message-ID: <51911604.2060805@redhat.com>
Date: Mon, 13 May 2013 11:34:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dmitry Monakhov <dmonakhov@openvz.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, EUNBONG SONG <eunb.song@samsung.com>,
        Jan Kara <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: EXT4 regression caused 4eec7
References: <6719519.5821368147110937.JavaMail.weblogic@epml17> <20130510192747.GA11707@thunk.org> <87y5bm53z3.fsf@openvz.org> <87txm96fkd.fsf@openvz.org> <87mws1eq6y.fsf@openvz.org> <20130511230559.GD26298@thunk.org> <87a9o01siw.fsf@openvz.org>
In-Reply-To: <87a9o01siw.fsf@openvz.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/13 4:01 AM, Dmitry Monakhov wrote:
> In fact '4eec70' are vexing because I have reviewed and tested this patch before
> it was marked as Review-by, but missed the bug. This is because xfstests
> was executed manually logs was full of warnings but tainted flag was not
> checked at the end. 

Can you elaborate on this?  What was logged, and is it something we could
try to pick up post-test in xfstests?

Thanks,
-Eric
