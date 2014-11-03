Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaKCMpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:45:23 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38692 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaKCMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:45:22 -0500
Message-ID: <545778DB.3030803@collabora.co.uk>
Date: Mon, 03 Nov 2014 13:45:15 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: of: Add support for parsing microvolts
 for suspend state
References: <1414813978-32233-1-git-send-email-dianders@chromium.org> <1414813978-32233-2-git-send-email-dianders@chromium.org> <54549EA6.5060007@collabora.co.uk> <20141103122948.GI3815@sirena.org.uk>
In-Reply-To: <20141103122948.GI3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 01:29 PM, Mark Brown wrote:
> 
> If you're reviewing something please don't quote the entire patch, the
> same rule applies as always - just include relevant context - and
> especially don't include your one line of content at the very end of the
> patch.  Otherwise people have to page through the entire thing to find
> what you've said (if they don't get fed up first).
> 

Yes, I usually add my {Review,Acked,Tested}-by tags at the end of the
commit message and remove the complete patch but since it was a 4-lines
patch I didn't think it was that bad.

Sorry about that, I will do it next time no matter the patch size.

Best regards,
Javier
