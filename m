Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaG3OtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:49:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34316 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaG3OtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:49:23 -0400
Date: Wed, 30 Jul 2014 07:49:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [fs] BUG: unable to handle kernel NULL pointer dereference at
 00000104
Message-ID: <20140730144918.GA32728@infradead.org>
References: <20140730041235.GJ16537@localhost>
 <20140730111420.GA759@infradead.org>
 <20140730123933.GA7717@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730123933.GA7717@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 08:39:33PM +0800, Fengguang Wu wrote:
> It's from this git tree:
> 
> git://people.freedesktop.org/~dvdhrm/linux fops

David, please make sure things touching VFS code go through
linux-fsdevel and the proper trees.  In the current form this gets a
strong NAK.
