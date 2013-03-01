Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3CAVbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:31:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3CAVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:31:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [patch] applicom: use correct array offset
Date: Fri, 1 Mar 2013 21:31:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20130301203146.GC22066@longonot.mountain>
In-Reply-To: <20130301203146.GC22066@longonot.mountain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303012131.37086.arnd@arndb.de>
X-Provags-ID: V02:K0:WO955iQcJlKwd5Xu3JmcZHXve7IFMTfCcgUg1V/2a0u
 eQr8LYrP+Nkh/Hr2pSwJRfxwGcA5sGaNpN5nRfAkC7UabXcWLo
 Wuj0vECMzdMePMvhd3OzIV/WxK7oT3hkFVuJ/3WViL850ARmdG
 k/Csg1rSeoitm3+hlzeeFNl+MA4wp4q1dCeZ/YphtIUn0qyqhL
 YzR7O463/j00IHbJ3HyTGH87ygKXhQQZaExcr7ECRowJ3WifAA
 81d9/SDTdEcz04LV9RdgGHJ7CokpK+z/9sIemsRoDF6/xeYkMm
 KL0zYj4Ft2osD8Clq5TfpD/raePrCYHLb75dl4q4264VsRXUo3
 jd3A2MEsRlJ2quNFfbb0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013, Dan Carpenter wrote:
> We're iterating through abps[] printing information, but here we
> use the wrong array index.  IndexCard comes from the user and in
> this case it was specifically not range checked because we didn't
> expect to use it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

Wow, that is a crappy driver ;-) Dave Woodhouse was apparently the last
person who understood it and had something to do with it, and that was back
in the 90s. It looks like the vendor actually has its own (much worse)
driver for this product line and only supports more recent cards than
our driver does. I doubt that there is anyone using this.

Should we just kill the driver?

	Arnd
