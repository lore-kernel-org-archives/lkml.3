Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaLXShs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:37:48 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:55825 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaLXShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:37:47 -0500
Date: Wed, 24 Dec 2014 20:37:37 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 3.19-rc1 refuse connection from bluetooth headset
Message-ID: <20141224183737.GA21428@t440s.P-661HNU-DI-F1>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201412241815.12922@pali>
 <20141224173652.GA16667@t440s.P-661HNU-DI-F1>
 <201412241932.27264@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412241932.27264@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali,

On Wed, Dec 24, 2014, Pali Rohár wrote:
> > Could you try the attached patch? I think the reason might be
> > the dependence on the HCI_CONNECTABLE flag that's only set if
> > the page scan was enabled through mgmt (which wouldn't be the
> > case with BlueZ 4.98).
> > 
> > Johan
> 
> Hi Johan! Thanks for quick reply. Your patch fixes my problem and 
> auto-connection of my bluetooth headset is working again. Will 
> you forward patch to mainline kernel?

Yes, we'll tag it from 3.17.x onwards where this was introduced.

Johan
