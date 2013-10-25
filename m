Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3JYXtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:49:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61020 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3JYXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:49:51 -0400
Date: Fri, 25 Oct 2013 16:49:48 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: [PATCH] max17042_battery: use SIMPLE_DEV_PM_OPS
Message-ID: <20131025234948.GD13859@teo>
References: <1381728411-21935-1-git-send-email-badarkhe.manish@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381728411-21935-1-git-send-email-badarkhe.manish@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 10:56:51AM +0530, Manish Badarkhe wrote:
> Use the SIMPLE_DEV_PM_OPS macro to declare the driver's
> pm_ops.
> 
> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>

Applied, thanks!

Anton
