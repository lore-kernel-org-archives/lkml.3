Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501AbaJ1D5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:57:00 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43664 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaJ1D4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:56:54 -0400
Date: Mon, 27 Oct 2014 23:56:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [percpu] Make the unit size of the first chunk the same
 as other chunks
Message-ID: <20141028035651.GB4751@mtj.dyndns.org>
References: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
 <20141027140826.GJ4436@htj.dyndns.org>
 <CADFvMYKRcqcZSbMz8sHGGknUC7p7i3MvGO5vKabrrzeWj+qUTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADFvMYKRcqcZSbMz8sHGGknUC7p7i3MvGO5vKabrrzeWj+qUTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 07:32:47PM -0400, Zhihui Zhang wrote:
> I am trying to make each CPU to have a full unit size in the first
> chunk, same as in all other chunks. Does this make sense?

And why are you trying to do that?  Unit size may be highly variable.
Why would it make sense to reserve memory area according to a value
which can fluctuate for reasons completely unrelated to actual percpu
memory usage?

Thanks.

-- 
tejun
