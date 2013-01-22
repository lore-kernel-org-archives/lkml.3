Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3AVKIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:08:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3AVKIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:08:22 -0500
Date: Tue, 22 Jan 2013 11:08:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: HID: clean up quirk for Sony RF receivers
In-Reply-To: <1358835638.6336.1.camel@nexus.lab.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1301221108090.20374@pobox.suse.cz>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>   <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>   <50F52986.2080002@lab.ntt.co.jp>   <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>   <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz> 
  <50F637D1.8070302@lab.ntt.co.jp>   <alpine.LNX.2.00.1301161141250.14768@pobox.suse.cz>  <50FE2A34.3050607@lab.ntt.co.jp> <1358835638.6336.1.camel@nexus.lab.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013, Fernando Luis Vázquez Cao wrote:

> Document what the fix-up is does and make it more robust by ensuring
> that it is only applied to the USB interface that corresponds to the
> mouse (sony_report_fixup() is called once per interface during probing).

Applied.

-- 
Jiri Kosina
SUSE Labs
