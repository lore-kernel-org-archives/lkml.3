Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaKZUbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:31:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaKZUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:31:36 -0500
Date: Wed, 26 Nov 2014 12:31:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8723au: core: fix checkpatch error: that open
 brace { should be on the previous line
Message-ID: <20141126203135.GA29182@kroah.com>
References: <1415699937-20318-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415699937-20318-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 03:28:57PM +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes following
> Error.
> 
> ERROR: that open brace { should be on the previous line

This patch does much more than that :(
