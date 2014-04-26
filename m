Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaDZQJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:09:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52536 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaDZQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:09:36 -0400
Message-ID: <535BD744.5030406@mev.co.uk>
Date: Sat, 26 Apr 2014 16:56:52 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, <devel@driverdev.osuosl.org>
CC: <hsweeten@visionengravers.com>, <gregkh@linuxfoundation.org>,
        <chase.southwood@yahoo.com>, <unixed@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: remove duplicate pointer assignments
 in attach functions
References: <20140426160429.4883f678@spike>
In-Reply-To: <20140426160429.4883f678@spike>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/14 15:04, Christian Engelmayer wrote:
> Some board pointer are assigned twice via comedi_board() in the comedi low
> level driver attach functions. Remove the duplicate assignment from the
> variable definition where the pointer is not used anyway until assigned later
> in the function when dev->board_ptr, that comedi_board() relies on, is setup
> correctly.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against v3.15-rc2 as well as branch staging-next
> of tree git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Looks good!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
