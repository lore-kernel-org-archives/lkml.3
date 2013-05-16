Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3EQDzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:55:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49984 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab3EQDzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:55:07 -0400
X-Sasl-enc: su5hnINVxzE88YqIFI4gZb3Vm55EptbGGDQM3oZUz4hM 1368762905
Date: Thu, 16 May 2013 18:14:12 -0400
From: Greg KH <greg@kroah.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Seungwon Jeon'" <tgih.jun@samsung.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: [PATCH 3.9-stable] mmc: dw_mmc: fix fifo access for 64-bit
Message-ID: <20130516221412.GA11289@kroah.com>
References: <000f01ce4a12$d77ccc30$86766490$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01ce4a12$d77ccc30$86766490$%choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:33:22PM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

It doesn't apply to the 3.9 tree, so it's going to be bit hard to do
this...

sorry,

greg k-h
