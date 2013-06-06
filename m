Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3FFQpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:45:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35667 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3FFQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:45:48 -0400
Message-ID: <51B0BCB9.6070505@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:45:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Alex Courbot <acourbot@nvidia.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com> <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com> <51B0446A.4090305@nvidia.com> <29610936-BB03-4844-888B-56E1C8E5DF4A@jcrosoft.com> <51B047FD.4020400@nvidia.com> <20130606145059.GU19468@game.jcrosoft.org> <51B0B61C.2000008@wwwdotorg.org> <20130606162943.GX19468@game.jcrosoft.org>
In-Reply-To: <20130606162943.GX19468@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 10:29 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
...
> I did reject this patch but put a warning I do not want to see a huge table
> if so => factorisation or parser

Did you mean "accept" here not "reject"?
