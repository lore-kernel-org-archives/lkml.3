Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaDVKhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:37:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28143 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaDVKhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:37:19 -0400
Date: Tue, 22 Apr 2014 13:36:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Camille Bordignon <camille.bordignon@gmail.com>
Cc: arve@android.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: android: Fix warning cast removes address
 space of expression
Message-ID: <20140422103653.GJ26890@mwanda>
References: <1397985057.12169.7.camel@vash.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397985057.12169.7.camel@vash.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 11:10:57AM +0200, Camille Bordignon wrote:
> Fix sparse warning "cast removes address space of expression"
> Add lost flag "__user" due to cast
> 
> Signed-off-by: Camille Bordignon <camille.bordignon@gmail.com>

This one is the most perfect version of this patch yet.  Unfortunately
a couple other people sent it before you.

regards,
dan carpenter

