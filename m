Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3HTFVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:21:00 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:56416 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3HTFU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:20:58 -0400
Message-ID: <5212FCA8.9040204@synopsys.com>
Date: Tue, 20 Aug 2013 10:50:40 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.stable
To: greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "noamc@ezchip.com" <noamc@ezchip.com>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARC: gdbserver breakage in Big-Endian configuration
 #1
References: <1375969958-16454-1-git-send-email-vgupta@synopsys.com> <C2D7FE5348E1B147BCA15975FBA2307513FD98@IN01WEMBXA.internal.synopsys.com> <20130819145734.GA15353@kroah.com>
In-Reply-To: <20130819145734.GA15353@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 08/19/2013 08:27 PM, greg Kroah-Hartman wrote:
> On Mon, Aug 19, 2013 at 09:08:49AM +0000, Vineet Gupta wrote:
>> Hi Greg,
>>
>> I'd posted these patches for stable backport. Do I need to do anything more to get them included.
>>
>> https://patchwork.kernel.org/patch/2841153/  [1/2] ARC: gdbserver breakage in Big-Endian configuration #1<https://patchwork.kernel.org/patch/2841153/>]
>> https://patchwork.kernel.org/patch/2841158/  [2/2] ARC: gdbserver breakage in Big-Endian configuration #2<https://patchwork.kernel.org/patch/2841158/>
> 
> I ignored them as I thought you were submitting them for upstream
> inclusion.  If they are already in Linus's tree, then take a look at the
> file, Documentation/stable_kernel_rules.txt for how to send a patch for
> inclusion into a stable release (hint, I need to know the git commit id
> that the patch has in Linus's tree, which I didn't see anywhere here.)


I'm sure I mentioned the commit-id in the patch. Hint, please look at annotation
within --->8--- blocks in changelogs.

The caveat however is we can't apply those exact commits as it is as that warrants
more changes to be pulled in. However I'm going by the last stable kernel rule "It
or an equivalent fix must already exist in Linus' tree (upstream)."

Anyhow, since both these patches are extracted from same commit, I'll respin a
single patch (with a small addition - again part of the same commit) and send it
over. OK !

Thx,
-Vineet
