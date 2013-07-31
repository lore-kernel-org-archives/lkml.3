Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab3GaAry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:47:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29581 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab3GaArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:47:52 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-27-51f85eb654fb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <007601ce8d06$13dbb890$3b9329b0$@samsung.com>
 <20130730135720.GC27962@kroah.com>
In-reply-to: <20130730135720.GC27962@kroah.com>
Subject: Re: [PATCH] Driver core: Add accessor for device tree node
Date: Wed, 31 Jul 2013 09:47:50 +0900
Message-id: <001001ce8d87$9545bd00$bfd13700$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMf4IZatV0JpNkk5AzycWHvoDEVlwG7mo1nls1wzaA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t8zQ91tcT8CDR7+MrWYs34Nm8XUh0/Y
	LOYfOcdqceDPDkaL5sXr2SwuL7zEanF51xw2i8MrDjA5cHgs+HyF3WPTqk42jzvX9rB5nJjx
	m8Vj/9w17B59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CVsfDxcqaCX0wVhx59YG5gXMHUxcjJ
	ISFgIvF1Yi8bhC0mceHeeiCbi0NIYBmjxNQZDxlhita2zGeBSCxilFg84QcjhPOLUeLglZtg
	7WwCahJfvhxmB7FFBEwlNr6fAlbELNDOJDHv7FqwfUICcRIHLvaBNXAK6Ev8WPoLrEFYwFmi
	ffFBsDiLgKpE69XPYPW8ApYSh959Z4GwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zxKkKEjvO
	vmaEOMJK4uii5+wQNSIS+168AztIQqCVQ2L/rElMEMsEJL5NPgQ0lAMoISux6QDUHEmJgytu
	sExglJiFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFCInzCDsZ7
	B6wPMSYDrZ/ILCWanA9MEHkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbF
	F5XmpBYfYmTi4JRqYDSRV6h3U9E9oX72KW9Z8YbfnOKPDoSzPlSaePv2/JRZTW/ux9sY2q1y
	bU4L8zTitbTbcbMnUORyMh/T1lKTJpMXRfXiAatfaku7r17iL6TLve3x0hMH7xiYpa9Pkf38
	v9A0+M4p5m8GWglFzxc6MvzxK2j/+7dvjs1ft9gpMdG/opzdb89wV2Ipzkg01GIuKk4EAFCZ
	XRUGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAd1tcT8CDb7tNbSYs34Nm8XUh0/Y
	LOYfOcdqceDPDkaL5sXr2SwuL7zEanF51xw2i8MrDjA5cHgs+HyF3WPTqk42jzvX9rB5nJjx
	m8Vj/9w17B59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkDdJaSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCO
	MWPh4+VMBb+YKg49+sDcwLiCqYuRk0NCwERibct8FghbTOLCvfVsXYxcHEICixglFk/4wQjh
	/GKUOHjlJhtIFZuAmsSXL4fZQWwRAVOJje+ngBUxC7QzScw7uxZsrJBAnMSBi31gDZwC+hI/
	lv4CaxAWcJZoX3wQLM4ioCrRevUzWD2vgKXEoXffWSBsQYkfk++B2cwCWhLrdx5ngrDlJTav
	ecsMcaqCxI6zrxkhjrCSOLroOTtEjYjEvhfvGCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzg9PFMagfjygaLQ4wCHIxKPLwOF74HCrEmlhVX5h5ilOBg
	VhLhlQ/6ESjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cDUllcSb2hsYmZkaWRmYWRibk6a
	sJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjBo71Djuz1px4VGT7xnT6UzfzgTet3iToqH5
	T0c+8WbvXp2AmdN27AnrtPkQ9+Fc0OOMqlerVjB/WzD/ybu/7R2PPl2x0wwp3bvsWuCqSLnE
	DH6f+ZsfsYd4/Opc2S37o+bgWbPrR0oaVTafW18jOaf9W+ecC/nft6gIFb2XFtPLfMrJUt2R
	Z6HEUpyRaKjFXFScCACDWNUJYwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 30, 2013 10:57 PM, Greg Kroah-Hartman wrote:
> On Tue, Jul 30, 2013 at 06:20:47PM +0900, Jingoo Han wrote:
> > Add the wrapper function for retrieving device tree node instead of
> > accessing dev->of_node directly.
> 
> Why?

Sorry, I cannot find the special reason why it should be used.
Please, ignore it. :)
Thanks.

Best regards,
Jingoo Han

