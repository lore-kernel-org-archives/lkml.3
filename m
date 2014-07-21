Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaGUIU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:20:28 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:29823 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbaGUIU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:20:26 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=G0PaaKbxzNgA:10 a=IkcTkHD0fZMA:10 a=EUspDBNiAAAA:8
 a=28_vjuM_Yj59CBH-yFcA:9 a=QEXdDO2ut3YA:10 a=HvliE7z8yqUA:10
 a=yaXswTZDrasA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIHANDLzFPD7hTU/2dsb2JhbABZgw6BKYJ4qzMBAQEBAQEGnjYBgRUWdoQDAQEEASNWBQsFBg4KAgIYDgICVwYTEYgpDKdChn+PdReBLIRPiVAHgniBTgWvVINGOy8
Date: Mon, 21 Jul 2014 10:20:23 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        "John W. Linville" <linville@tuxdriver.com>
Message-ID: <456542272.930781.1405930823519.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <87d2cz15yp.fsf@kamboji.qca.qualcomm.com>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be> <1405866332-24652-5-git-send-email-fabf@skynet.be> <87d2cz15yp.fsf@kamboji.qca.qualcomm.com>
Subject: Re: [PATCH 14/30] ath6kl: remove unnecessary break after return
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 21 July 2014 at 10:17 Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>
> Fabian Frederick <fabf@skynet.be> writes:
>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> Who is taking this patch? Please let me know if I should apply it to my
> tree.

Thanks Kalle, David Miller already applied this patchset to net-next.

Regards,
Fabian
>
> --
> Kalle Valo
