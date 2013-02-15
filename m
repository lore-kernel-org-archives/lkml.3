Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab3BOS4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:56:15 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:13377 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3BOS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:56:14 -0500
Message-ID: <511E84C7.9060806@atmel.com>
Date: Fri, 15 Feb 2013 18:56:07 +0000
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 7/7] staging/ozwpan: Fix NULL vs zero in ozhcd.c (sparse
 warning)
References: <20130215084517.GB6802@mwanda> <1360938148-19225-1-git-send-email-peterhuewe@gmx.de> <1360938148-19225-7-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1360938148-19225-7-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter, Looks good to me.

Acked-by: Rupesh Gujare <rupesh.gujare@atmel.com>

-- 
Regards,
Rupesh Gujare

