Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117Ab3GLRLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:11:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36713 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab3GLRL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:11:28 -0400
Message-ID: <51E038AC.6060107@zytor.com>
Date: Fri, 12 Jul 2013 10:11:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org>
In-Reply-To: <20130712005023.GB31005@thunk.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 05:50 PM, Theodore Ts'o wrote:
> 
> At least at one point in the past...
> 

And at at least one *other* point in the past, Linus stated that
"holding back anything with a Cc: stable waiting for the merge window is
wrong".  This would imply that the post-rc5-or-so policy and the stable
policy are effectively the same.

Now, "policy" is a big word, and Linus and the maintainers generally
have exercised discretion here and I would think that a lot of it really
depends on the trust relationship between Linus and maintainer, or
between maintainer and submaintainer.  I generally try to flag to Linus
when I push something that he may consider questionable, and I very
rarely get

> Maybe the pendulum has swung too far in the direction of holding back
> changes and trying to avoid the risk of introducing regressions;
> perhaps this would be a good topic to discuss at the Kernel Summit.

I think it would, to the extent such a policy is needed and workable.  I
think there is a serious risk in getting to hung up on policy.

	-hpa

