Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab3CYXjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:39:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58854 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011Ab3CYXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:39:49 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-f7-5150e044c5ca
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, "'Magnus Damm'" <magnus.damm@gmail.com>,
        "'Simon Horman'" <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        "'Guennadi Liakhovetski'" <g.liakhovetski+renesas@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
 <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
 <00da01ce2917$54856ce0$fd9046a0$%han@samsung.com>
 <20130325101442.GJ18316@opensource.wolfsonmicro.com>
In-reply-to: <20130325101442.GJ18316@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
Date: Tue, 26 Mar 2013 08:39:47 +0900
Message-id: <00cb01ce29b2$095f6f90$1c1e4eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4pQZiXLdpFaz04QreWqQXBFvYVxwAb9xKg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zga7Lg4BAg+/XWC3mrF/DZvFv9ik2
	iwOzH7Ja3Jz+iNni/cZ5TBbNW78yWlxeeInV4kTfB1aLy7vmsFk8WP2WzWL3rqesFqe7WR14
	PHbOusvu8eFjnMeJGb9ZPOadDPQ4P2Mho8fLib/ZPPbM/8Hq0bdlFaPHnJ/fWDw+b5IL4Iri
	sklJzcksSy3St0vgyjjX9Ie14ApLxYxNc5gbGA8xdzFyckgImEj8nLSYCcIWk7hwbz0biC0k
	sIxRYuL6eJiaVwvbmSDiixglHt6X62LkArJ/MUrM3bgfrIFNQE3iy5fD7F2MHBwiAmYSPw/y
	gNQwCxxjlpg/YwkTRMMbRompl06ygDRwCjhKzP61mh3EFhawldiy+y4jSDOLgKrEps2mIGFe
	oHD3/Z3sELagxI/J98BamQW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX12IE4wkzl/NhagQkdj3
	4h0jyAUSAls4JDo6msB+ZxEQkPg2+RALRKusxKYD0CCRlDi44gbLBEaJWUgWz0KyeBaSxbOQ
	rFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIyQtTNzBeP+A9SHGZKD1E5mlRJPzgWkl
	ryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M/Cp+
	sZZbzRe5ijyqeVdy8uV5not+boIvN/N/9u1/dPYdz9JQkz/qrfMjQyo/SIuKvrqWfG73LqH7
	kWrq9VvsX/182uG4MGVxgSaDbt3cgy3ir0WdhZhP9Nx5KH3HuWixzq2FfX4nLhl+qiizedGz
	Y9emcsUXQsYF+2cca93weNqrQwdFJQLZlViKMxINtZiLihMB1ZOlWCEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jAV2XBwGBBn+dLOasX8Nm8W/2KTaL
	A7MfslrcnP6I2eL9xnlMFs1bvzJaXF54idXiRN8HVovLu+awWTxY/ZbNYveup6wWp7tZHXg8
	ds66y+7x4WOcx4kZv1k85p0M9Dg/YyGjx8uJv9k89sz/werRt2UVo8ecn99YPD5vkgvgimpg
	tMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulpJoSwx
	pxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHGu6Q9rwRWWihmb5jA3MB5i7mLk
	5JAQMJF4tbCdCcIWk7hwbz0biC0ksIhR4uF9uS5GLiD7F6PE3I37wRJsAmoSX74cZu9i5OAQ
	ETCT+HmQB6SGWeAYs8T8GUuYIBreMEpMvXSSBaSBU8BRYvav1ewgtrCArcSW3XcZQZpZBFQl
	Nm02BQnzAoW77+9kh7AFJX5MvgfWyiygJbF+53EmCFteYvOat8wgrRIC6hKP/upCnGAkcf5q
	LkSFiMS+F+8YJzAKzUIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOCk80x6B+OqBotDjAIcjEo8vBxhAYFCrIllxZW5hxglOJiVRHiPXQAK8aYkVlalFuXHF5Xm
	pBYfYkwGenMis5Rocj4wIeaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUI
	ZgsTB6dUAyNr4PU9upzrWyRn7dzwV/fU0hPV62cv54j10P2/QmRTwJxbTwK37XZZq+Hhv1Fa
	mokho//31dRLLovvRj1P7XN5e7IyRqylyj5f8tYvP2tGz9zyAvk6Re0TOi+Ljrv6Gq/3YXqy
	gp+Ta/fMVblbs+0ML6+O/uf/o/yt5uvzxmceMOxRf1e2hUmJpTgj0VCLuag4EQDwFrSufgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 25, 2013 7:15 PM, Mark Brown wrote:
> 
> On Mon, Mar 25, 2013 at 02:12:21PM +0900, Jingoo Han wrote:
> > On Saturday, March 23, 2013 1:16 AM, Guennadi Liakhovetski wrote:
> 
> > But, there is a typo in comment.
> > > +		 * At least one su2-auto-curr* must be specified iff
> > s/iff/if
> 
> Are you sure that's a typo?  "Iff" is a bit of mathematical jargon
> which means "if and only if" that's fairly often used in a computing
> context.

Oh, it's my mistake.

'xor' is used; thus, it is not a typo.
 Thank you for your comment.

Best regards,
Jingoo Han

