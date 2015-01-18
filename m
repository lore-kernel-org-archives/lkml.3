Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbbARAFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:05:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbARAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:05:18 -0500
Date: Sat, 17 Jan 2015 16:02:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>,
        devel@driverdev.osuosl.org, Peng Tao <bergwolf@gmail.com>,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org,
        Jinshan Xiong <jinshan.xiong@intel.com>
Subject: Re: [PATCH 2/2] staging: lustre: declare internal symbols as static
Message-ID: <20150118000214.GA25744@kroah.com>
References: <1421188383-14216-1-git-send-email-luca@lucaceresoli.net>
 <1421188383-14216-2-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421188383-14216-2-git-send-email-luca@lucaceresoli.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:33:03PM +0100, Luca Ceresoli wrote:
> Fixes dozens of sparse warnings like:
>   warning: symbol 'cfs_tracefile_sem' was not declared. Should it be static?
> 
> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Peng Tao <bergwolf@gmail.com>
> Cc: Jinshan Xiong <jinshan.xiong@intel.com>
> Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
> Cc: HPDD-discuss@lists.01.org
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org

This patch fails to apply to my staging-next branch, sorry :(

greg k-h
