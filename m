Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3DWPzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:55:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45139
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756318Ab3DWPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:54:57 -0400
Date: Tue, 23 Apr 2013 09:54:43 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        Namjae Jeon <linkinjeon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>, Shaohua Li <shli@kernel.org>,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] block: fix max discard sectors limit
Message-ID: <20130423155443.GH11851@kernel.dk>
References: <1366722406-2899-1-git-send-email-linkinjeon@gmail.com>
 <1366724561.1930.3.camel@dabdike>
 <CAMo8BfJLB7DJVwWaxf7T3XWrs3igzEc=73EpeB1waeh0Ha5vdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMo8BfJLB7DJVwWaxf7T3XWrs3igzEc=73EpeB1waeh0Ha5vdQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23 2013, Max Filippov wrote:
> On Tue, Apr 23, 2013 at 5:42 PM, James Bottomley
> <jbottomley@parallels.com> wrote:
> > On Tue, 2013-04-23 at 22:06 +0900, Namjae Jeon wrote:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > Hey, it's very impolite to send a patch I just gave you as a suggestion
> > to fix the issue under your own authorship.
> >
> > What we need to know is has this been tested ... there's no tested-by
> > tags (and there also should really be a reported by).
> 
> I can confirm that this patch also fixes the original issue.
> Tested-by: Max Filippov <jcmvbkbc@gmail.com>

Goodie. Namjae, please re-send with properly attributed patch and I'll
get this applied.

-- 
Jens Axboe

