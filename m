Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbaLKUqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:46:01 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:38932 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbaLKUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:46:00 -0500
Date: Thu, 11 Dec 2014 20:40:30 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Alan Tull <atull@opensource.altera.com>, kbuild-all@01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH socfpga-nex] staging: fpga manager: socfpga_fpga_ops can
 be static
Message-ID: <20141211204030.42c33e71@lxorguk.ukuu.org.uk>
In-Reply-To: <20141211014324.GA73956@lkp-sb04>
References: <201412110903.GCuPHwdi%fengguang.wu@intel.com>
	<20141211014324.GA73956@lkp-sb04>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2014 09:43:24 +0800
kbuild test robot <fengguang.wu@intel.com> wrote:

> drivers/staging/fpga/socfpga.c:655:25: sparse: symbol 'socfpga_fpga_ops' was not declared. Should it be static?
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Ought to be const as well by the look of it - we don't want function
pointers in patchable memory spaces.
