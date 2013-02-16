Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3BPVk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:40:57 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37144 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3BPVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:40:56 -0500
Date: Sat, 16 Feb 2013 13:36:49 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq2415x_charger: Add support for offline and 100mA mode
Message-ID: <20130216213648.GD1741@lizard.sbx05280.losalca.wayport.net>
References: <1360517538-1022-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360517538-1022-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 06:32:18PM +0100, Pali Rohár wrote:
> * Renamed mode BQ2415X_MODE_NONE to BQ2415X_MODE_OFF
>   because this mode turning chaging completly off
> 
> * Added new mode BQ2415X_MODE_NONE which enable charging
>   with maximal current limit 100mA (this is minimal safe
>   value for bq2415x chips)
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Applied, thanks a lot!

Anton
