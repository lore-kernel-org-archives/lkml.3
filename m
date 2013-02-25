Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3BYCNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:13:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51947 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759527Ab3BYCNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:13:17 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-1d-512ac8bb12df
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301ce10bf$028176c0$07846440$%han@samsung.com>
 <20130222134418.a86e78b1.akpm@linux-foundation.org>
In-reply-to: <20130222134418.a86e78b1.akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: devres: Fix misplaced #endif
Date: Mon, 25 Feb 2013 11:13:14 +0900
Message-id: <01f301ce12fd$ab3fe400$01bfac00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4RRcXXmxvP7281SiadEpnaN8lsHQBt7nnA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zA93dJ7QCDSYd4LW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ31rEC/awV2zu62JuYHzB2sXIwSEhYCLxdx5PFyMnkCkmceHe
	erYuRi4OIYFljBLPt9xggkiYSOxd+JQZIrGIUWLflI/sEM5sJom2aSsZQarYBNQkvnw5zA4y
	VURAX6KtRQPEZBZwkTg6TQSkQkigWOLvmuPMIGFOAQeJlb+TQcLCAmYSXw5fYAWxWQRUJea9
	PAG2llfAVmLR5idsELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGeEVd4tFfXZCwiICRxMqr
	09ghSkQk9r14xwhysITAInaJ5/MPQO0SkPg2+RALRK+sxKYDzBDfSkocXHGDZQKjxCwkm2ch
	2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRESUX07GG8esD7EmAy0fiKz
	lGhyPjAi80riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBUe0nc/vjr9yZu+d5MM1y2ppUmndxrplW8qcD5z3NJx8sr42c26PMwMxYa7orY3Vb1Iw1
	12wvZx1yOnilkuVwZmqB9CLb+bXpvFVHF9u0p4dc4vUsXPex66ruJ0uh/drpxzKWrbDf8Nb9
	pJ0D38LyavegnHpD09aYio3rlHYIzk572vi+bvkPJZbijERDLeai4kQAiXkQxL4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgO7uE1qBBhtOclpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjG8t4gV72Cs293UxNzC+
	YO1i5OSQEDCR2LvwKTOELSZx4d56ti5GLg4hgUWMEvumfGSHcGYzSbRNW8kIUsUmoCbx5cth
	oAQHh4iAvkRbiwaIySzgInF0mghIhZBAscTfNceZQcKcAg4SK38ng4SFBcwkvhy+ALaWRUBV
	Yt7LE0wgNq+ArcSizU/YIGxBiR+T77GA2MwCWhLrdx5ngrDlJTaveQs2UkJAXeLRX12QsIiA
	kcTKq9PYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBEfsM+kdjKsaLA4xCnAwKvHwNqzUChRiTSwrrsw9xCjBwawkwqsZChTiTUmsrEot
	yo8vKs1JLT7EmAz06ERmKdHkfGAyySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs
	1NSC1CKYLUwcnFINjEue+a+PZLz/bZ1+cSTrhvKHs4UPPN+QW3aT7+Mdhcrtt3pYdYPvCNgk
	mZ+taJZjZPwj+VE5VP3VsVDdP8bvH/s4Xa4WMqpRuR/QEqXMdinZ9vF9jXIm9fO8d+ckh6rr
	O7BWTZY9dUtfn2PKL31Fvwk+Qav3iAuKWFso2i577+J4f6HPhD0GSizFGYmGWsxFxYkAxiX6
	FBwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 6:44 AM, Andrew Morton wrote:
> 
> On Fri, 22 Feb 2013 14:39:40 +0900
> Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > A misplaced #endif causes link errors related to pcim_*() functions.
> >
> > --- a/lib/devres.c
> > +++ b/lib/devres.c
> > @@ -227,6 +227,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
> >  			       devm_ioport_map_match, (void *)addr));
> >  }
> >  EXPORT_SYMBOL(devm_ioport_unmap);
> > +#endif /* CONFIG_HAS_IOPORT */
> >
> >  #ifdef CONFIG_PCI
> >  /*
> > @@ -432,4 +433,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
> >  }
> >  EXPORT_SYMBOL(pcim_iounmap_regions);
> >  #endif /* CONFIG_PCI */
> > -#endif /* CONFIG_HAS_IOPORT */
> 
> More details needed, please.  This code is pretty old and it's
> surprising that errors are popping up now.

OK, I will add more detailed commit message.
Thank you.

Best regards,
Jingoo Han



