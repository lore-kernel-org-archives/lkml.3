Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaLPOuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:50:12 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39213 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLPOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:50:10 -0500
Message-ID: <5490469A.7010606@collabora.com>
Date: Tue, 16 Dec 2014 09:50:02 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBTdQ==?= =?UTF-8?B?cmVhdQ==?= 
	<frederic.sureau@vodalys.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 CSC and scaler
References: <CAL8zT=hAVi2-io3POmj9Lp1AF11ovg6bqCMPRp_w_QySAgFGtw@mail.gmail.com> <548F272E.3040808@gmail.com> <548F2DD6.70805@collabora.com> <CAL8zT=jNis3VN11xN82fci5dA5f0TwAAhkBVq2+5TaKpmm_S-Q@mail.gmail.com> <1418736635.3374.64.camel@pengutronix.de> <54903E88.2070701@collabora.com> <CAL8zT=hq5mx71eB8dBea2qAuESjcLYremb81Vj-BjjTd+iA2-g@mail.gmail.com>
In-Reply-To: <CAL8zT=hq5mx71eB8dBea2qAuESjcLYremb81Vj-BjjTd+iA2-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 2014-12-16 09:27, Jean-Michel Hautbois a écrit :
> Have you already started something about that ?
Yes, currently I do cropping right if there is no scaling. Doing this 
with S_CROP is really ackward, but very few m2m driver has been ported 
to G_SELECTION yet. The v4l2transform was tested to run with Exynos 4 
FIMC driver. There was still issue with such driver doing middle 
rounding for alignment. This has been reported on this list. The 
proposed solution is to add flags to our internal alignment method, and 
update these driver to pick a direction.

Nicolas
