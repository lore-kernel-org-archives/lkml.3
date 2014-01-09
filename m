Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaAIAgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:36:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58815 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485AbaAIAgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:36:01 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-fc-52cdeeefb711
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
 <002101cf0c0d$6d90d470$48b27d50$%han@samsung.com>
 <20140108171538.GJ31886@sirena.org.uk>
In-reply-to: <20140108171538.GJ31886@sirena.org.uk>
Subject: Re: [PATCH 2/3] regulator: mc13892: Fix checkpatch issue
Date: Thu, 09 Jan 2014 09:35:59 +0900
Message-id: <004e01cf0cd2$c493f4d0$4dbbde70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8MlUQlk7BOh3XzT9SIow3JukJIwQAPPiag
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd33784GGczpsLGY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF3+2bWBxYPXbOusvusWlVJ5tH/18Dj74tqxg9Pm+SC2CN4rJJSc3JLEst
	0rdL4MrYtnE3c8FMloqtbZ/YGxiXMHcxcnJICJhIbLx7lw3CFpO4cG89kM3FISSwjFHiw4Vz
	bDBFj1/MYYRITGeUmL34MTuE84tR4sH2tywgVWwCahJfvhwGSnBwiAioSvx/5Q4SZhaYxiix
	6qEtRP0sRolHy96ygyQ4BYwllrRsYgKxhQUcJdbueg1mswD1/pq6mRVkDq+ArcSGgwogYV4B
	QYkfk++xQMzUkli/8zgThC0vsXnNW2aQcgkBdYlHf3UhLjCSmPBZG6JCRGLfi3dg50sI3GKX
	2DTvACvEJgGJb5MPsUC0ykpsOgANE0mJgytusExglJiFZPEsJItnIVk8C8mKBYwsqxhFUwuS
	C4qT0osM9YoTc4tL89L1kvNzNzFCorR3B+PtA9aHGJOB1k9klhJNzgdGeV5JvKGxmZGFqYmp
	sZG5pRlpwkrivEkPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MC7uXRP51aN1ilp0WcMO
	G71nfdfmTH1YZ+KoonDl3+OkI5lPz0qHXz/pVVHxnzlVXexdBvcEhnttktOOcK3rizcw/mi2
	r+t47pe8f7lRrNyebx9M8V/yMLHs5kxrwQPH+U4Zn1X7JvnL84l811rOJzfnLri95ddv/gUh
	Bzbp1fJf2PpQrS/yuK4SS3FGoqEWc1FxIgC4WjvG6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd33784GGSz4ZG4x9eETNovLCy+x
	Wny70sFkcXnXHDaLv9s3sTiweuycdZfdY9OqTjaP/r8GHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsW3jbuaCmSwVW9s+sTcwLmHuYuTkkBAwkXj8
	Yg4jhC0mceHeerYuRi4OIYHpjBKzFz9mh3B+MUo82P6WBaSKTUBN4suXw0AJDg4RAVWJ/6/c
	QcLMAtMYJVY9tIWon8Uo8WjZW3aQBKeAscSSlk1MILawgKPE2l2vwWwWoN5fUzezgszhFbCV
	2HBQASTMKyAo8WPyPRaImVoS63ceZ4Kw5SU2r3nLDFIuIaAu8eivLsQFRhITPmtDVIhI7Hvx
	jnECo9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgHPpHYw
	rmywOMQowMGoxMO7ovhskBBrYllxZe4hRgkOZiUR3hPngUK8KYmVValF+fFFpTmpxYcYk4He
	nMgsJZqcD0xPeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA
	eHb2K7vKe6Em4ienF28saVvTWGC17BC7+S6XhdzflY4pLRJJt66WldriW1KWkXBbuXiOeB6H
	kO0L9xuTuFkZ15U/m1xpP+FmoBpDuNl/x08Prxh1M6z9q/q1ecVhr9iXBxcslZxw9l1+pP1P
	qwC7qIZYwc0b2+vPGhmL180Pz8ptmPnEqX+uEktxRqKhFnNRcSIAF8DqnEUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 09, 2014 2:16 AM, Mark Brown wrote:
> On Wed, Jan 08, 2014 at 10:03:22AM +0900, Jingoo Han wrote:
> > Fix the following checkpatch warnings.
> >
> >   WARNING: Avoid unnecessary line continuations
> >   WARNING: line over 80 characters
> 
> This doesn't apply against current code, the same changes have already
> been made by you in October.

Sorry for annoying you.
I checked this patch applied to 'mc13892' branch in regulator
git tree. Thank you. :-)
Happy New Year!

Best regards,
Jingoo Han

