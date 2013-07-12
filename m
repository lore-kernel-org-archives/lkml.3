Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965205Ab3GLS2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:28:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38133 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256Ab3GLS23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:28:29 -0400
Message-ID: <51E04AB9.1000003@zytor.com>
Date: Fri, 12 Jul 2013 11:28:09 -0700
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
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712025745.GA24086@tuxdriver.com> <20130712033430.GA3798@kroah.com> <51E03AEE.5010403@zytor.com> <20130712172836.GA7627@kroah.com> <20130712175718.GA342@thunk.org> <51E0480A.2040905@zytor.com>
In-Reply-To: <51E0480A.2040905@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:16 AM, H. Peter Anvin wrote:
> 
> This relates to the "a posteori metadata" problem with git.  In theory I
> think git notes should handle those, but I have to admit that git notes
> somewhat creep me out because there doesn't seem to be any version
> control on them, and as far as I can tell there is only one note per object.
> 

OK, just read up some more on git notes, and *both* the assumptions I
had made about git notes were fundamentally wrong.  Not sure how well
they would scale, though, but stuffing metadata like additional
Acked-by:, Tested-by: and Cc: stable into notes seems more viable after
reading the spec.

	-hpa


