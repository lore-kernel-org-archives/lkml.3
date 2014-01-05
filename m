Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaAEXvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:51:05 -0500
Received: from nm20-vm5.access.bullet.mail.bf1.yahoo.com ([216.109.115.116]:24486
	"HELO nm20-vm5.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbaAEXvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:51:03 -0500
X-Yahoo-Newman-Id: 103874.25580.bm@smtp114.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pV6abJ0VM1kjxjxwIpMv7Z1LfhlIIUDA7m7TEwlAyw_v7uC
 mhdf2sfu9rSObc0djzJR92ZDbquUZE8QDK3N3kxUSfpcMfjQasO4ZVeUZgmR
 VaYCxonU_0zw6rcz3oHGpf_pb3dmIK4U0Q1nc2mxAGlpsdzdrY0GM31Tnnwe
 YinlKQ5K1ZTNDKBCkAPD_Rt7mxsWk1ychssz0WI6PVkiMm_7sPPlSt82Ta14
 vWwZpIVMy3A3Gk7fpHuE9rhW2i0Bz24nARaKw.3x_aWmzRg8AkfAZsTm9tG8
 hdhsBb.wj3TVWPRhDVHFzPxanVRXG.43pGyltcJMqTyCEI0Xgw9J_lIl854u
 O8ZLfJdat7bH97EEAkZn_LiJNZ3HZGIsmNLmESZEG6S9hvu0p1Sf0YKDGpnD
 N.l9.HIPIjCTColVeUlmPF1Td6tqvd6S.lcwjpen8cqP5ae4HaGYmtthtmYQ
 DuPHUNUL58xPkVdLiT5MT7bCILB6lyFkVUgzMg10CP7VNUwSFgiTrvvkjXKa
 4QWwjzi31RnrOgM9OgWrnPPkfGOrZxKDOrZw.VJPbMBh5HrrBX1WrVmzITlQ
 p
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain [98.138.31.74])
        by smtp114.sbc.mail.ne1.yahoo.com with SMTP; 05 Jan 2014 23:51:02 +0000 UTC
Message-ID: <52C9F036.7030704@att.net>
Date: Sun, 05 Jan 2014 17:52:22 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Daniel Santos <daniel.santos@pobox.com>
Subject: Re: *[PATCH]* spidev: fix hang when transfer_one_message fails
References: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1388965166-27334-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the "[PATCH]" prefix didn't get in the subject.
