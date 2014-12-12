Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaLLWxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:53:16 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:52545 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752130AbaLLWxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:53:15 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 17:53:14 EST
Message-ID: <548B6FFD.4040607@lougher.demon.co.uk>
Date: Fri, 12 Dec 2014 22:45:17 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>, toki clover <tokiclover@gmail.com>
CC: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, texstar@gmail.com, martin@mvath.de,
        Guan Xin <guanx.bac@gmail.com>, dave@vasilevsky.ca, szycha@gmail.com,
        blyons@students.naropa.edu, afm404@gmail.com, hugochevrain@gmail.com
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk> <CAGw_SrN6tZyXRx6pxkpnhWc2U5845HRbfzhOK5v9qkjWejFpmA@mail.gmail.com> <20141212155605.GA31859@wolff.to>
In-Reply-To: <20141212155605.GA31859@wolff.to>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDF-HostID: 4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/14 15:56, Bruno Wolff III wrote:
> On Fri, Dec 12, 2014 at 13:23:19 +0100,
>   toki clover <tokiclover@gmail.com> wrote:
>>
>> Now, I did not see any Linux FS devs activity/response to this... What
>> a waste of time because if those patch don't make it for this merge
>> window, rebasing/reposting will be, again, necessary.
>
> The patches got pulled into linux-next. For XZ, the patches sat in linux-next for a full release cycle. I don't know whether or not if that is the plan for the lz4 patches.
> .
>

The plan is to send out the merge request this weekend.

I've been too busy this week with my main job to do the merge request,
sorry (I'll probably be working past midnight again tonight, the
weeks leading up to Christmas are always really busy).

Phillip

