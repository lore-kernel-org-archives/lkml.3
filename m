Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaG3LOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:14:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55959 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaG3LOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:14:24 -0400
Date: Wed, 30 Jul 2014 04:14:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [fs] BUG: unable to handle kernel NULL pointer dereference at
 00000104
Message-ID: <20140730111420.GA759@infradead.org>
References: <20140730041235.GJ16537@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730041235.GJ16537@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 12:12:35PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Where is this coming from?  Bloating struct file for device specific
stuff really isn't acceptable anyway.

