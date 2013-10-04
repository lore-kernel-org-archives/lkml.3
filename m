Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3JDFSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:18:18 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49946 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3JDFSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:18:16 -0400
Message-ID: <1380863911.4265.35.camel@porter.coelho.fi>
Subject: Re: [PATCH] net: wireless: wl1251: update firmware path
From: Luca Coelho <luca@coelho.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 04 Oct 2013 08:18:31 +0300
In-Reply-To: <1380718848-26634-1-git-send-email-balbi@ti.com>
References: <1380718848-26634-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 08:00 -0500, Felipe Balbi wrote:
> TI firmwares are located under ti-connectivity
> directory. Update path to make sure driver can
> find and load firmware blob.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Applied, thanks Felipe!

--
Luca.

