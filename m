Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaCFJF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:05:57 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43603 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaCFJFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:05:47 -0500
Message-ID: <53183A54.3000102@mev.co.uk>
Date: Thu, 6 Mar 2014 09:05:24 +0000
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Fred Akers <knivey@botops.net>
CC: "greg@kroah.com" <greg@kroah.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Staging: comedi: range: tidy up comedi_check_chanlist()
References: <20140306062333.GA19862@kroah.com> <1394089039-12408-1-git-send-email-knivey@botops.net>
In-Reply-To: <1394089039-12408-1-git-send-email-knivey@botops.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 06:57, Fred Akers wrote:
> Refactor this function to remove an extra indent level
>
> Signed-off-by: Fred Akers <knivey@botops.net>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
