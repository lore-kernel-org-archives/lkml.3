Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab3GLSRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:17:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37882 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964938Ab3GLSRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:17:08 -0400
Message-ID: <51E0480A.2040905@zytor.com>
Date: Fri, 12 Jul 2013 11:16:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com> <20130712172836.GA7627@kroah.com> <20130712175718.GA342@thunk.org>
In-Reply-To: <20130712175718.GA342@thunk.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 10:57 AM, Theodore Ts'o wrote:
> On Fri, Jul 12, 2013 at 10:28:36AM -0700, Greg Kroah-Hartman wrote:
>> On Fri, Jul 12, 2013 at 10:20:46AM -0700, H. Peter Anvin wrote:
>>> On the subject of the stable tree: could we get a standard format for
>>> requesting post-inclusion elevation of patches to stable status?  It
>>> isn't all that unusual that the need for -stable is highlighted after a
>>> patch has been included in a maintainer's tree, and rebasing to add
>>> stable metadata annoys Linus.
>>
>> After it's in Linus's tree, just send the git id of the patch to
>> stable@vger.kernel.org, along with what stable tree(s) you want to see
>> the patch backported to.
>>
>> Documentation/stable_kernel_rules.txt should be pretty explicit about
>> how to do this, but if not, patches to it are always welcome.
> 
> FWIW, Documentation/stable_kernel_rules.txt currently says that you
> should send the patch.  I checked to see whether sending the git id
> was sufficient, and upon reading stable_kernel_rules.txt, decided to
> simply run git format-patch/git send-email of the commits in mainline.
> Apparently no one seemed to mind....
> 

My main point was actually to have something that could be automatically
recognized and flagged by maintainer tools, which an informal email
really can't.

This relates to the "a posteori metadata" problem with git.  In theory I
think git notes should handle those, but I have to admit that git notes
somewhat creep me out because there doesn't seem to be any version
control on them, and as far as I can tell there is only one note per object.

	-hpa


