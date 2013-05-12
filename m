Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3ELJnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 05:43:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62830 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3ELJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 05:43:42 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a9-518f644c8413
Date: Sun, 12 May 2013 09:43:40 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: Re: Re: EXT4 regression caused 4eec7
To: "Theodore Ts'o" <tytso@mit.edu>, Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jan Kara <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130512094125781@eunb.song
Msgkey: 20130512094125781@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130512094125781@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <30361646.2431368351817853.JavaMail.weblogic@epml17>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zlq5PSn+gwab3LBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjx/J57AXLWCo+/RNoYJzC0sXIySEkoCLR8v87I4gtIWAicbbj
	MRuELSZx4d56IJsLqGYZo0T7+gNMMEV9l66yQCTmM0qsO9QGNolFQFXixudesG42AW2Jt18e
	sILYwgK6EoeWXAerERHwl5jwcDpYM7PAP0aJHdP/skOcIS8x+fRlMJtXQFDi5MwnLBDblCT2
	PlzMAhFXljh4cREzRFxCYtb0C6wQNq/EjPanUPVyEtO+roGqkZY4P2sDI8w7i78/horzSxy7
	vQPoGw6w3if3g2HG7N78Bep7AYmpZw5CtapLzF04GWoVn8SahW9ZYMbsOrWcGab3/pa54ABi
	FlCUmNL9kB3C1pL48mMfG7q3eAUcJN713GCewKg8C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyU
	XmSqV5yYW1yal66XnJ+7iRGSGCbuYLx/wPoQYzIwTiYyS4km5wMTS15JvKGxmZGFqYmpsZG5
	pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGH0tmhuuT1g3+UtM9LNjkgtE
	Lxo904i70/Rt262ETRu3szc2u6yN6WUOK9n36vwK7et/b19eKHNa5gtn3E7vyFBvgemGrZ0B
	3cqhZ050ZS50fpJ8Mih1nd+pf4fX/+wT3bViY8exf2Hq/RbF89+6epusCDkSE3WxKfargLEt
	/5KWUtvjJpL3lJVYijMSDbWYi4oTAYWfw6giAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2DF2flP5Ag22rmSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xo7l89gLlrFUfPon0MA4haWLkZNDSEBFouX/d0YQW0LARKLv0lUWCFtM4sK99WxdjFxANfMZ
	JdYdagNLsAioStz43MsGYrMJaEu8/fKAFcQWFtCVOLTkOliNiIC/xISH01lAmpkF/jFK7Jj+
	lx1im7zE5NOXwWxeAUGJkzOfQG1Tktj7cDELRFxZ4uDFRcwQcQmJWdMvsELYvBIz2p9C1ctJ
	TPu6BqpGWuL8rA2MMFcv/v4YKs4vcez2DqYuRg6w3if3g2HG7N78hQ3CFpCYeuYgVKu6xNyF
	k6FW8UmsWfiWBWbMrlPLmWF672+ZywRiMwsoSkzpfsgOYWtJfPmxjw3dW7wCDhLvem4wT2CU
	m4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w0itOzC0uzUvXS87P3cQITlHPFu1g/Hfe+hCj
	AAejEg9vwv6+QCHWxLLiytxDjBIczEoivPfj+gOFeFMSK6tSi/Lji0pzUosPMSYDY3Ais5Ro
	cj4wfeaVxBsaGxgbGlqaG5gaGlmQJqwkzvus1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+PsyQcT
	jbUa2G4/dd0yy9Nt3l7eO+lc/hXvT5u7LDnPvNW+sWTjeVFTpYbn26YyBOas0OBknmYvvdBH
	TKVA5HjDMzfhKzIvfjqfCMn23W7SvGa+vE7bLiOZiry0h1fjwpgXpYsttL6Wf/P8QvMHyzb0
	5Er88V3+/Ex3896HK8u2TLU+dmrjlEAlluKMREMt5qLiRACowru8lQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4C9hoWu029185



> Since at this point it's safer to rollback the change and we can
> investigate more deeply how to fix it correctly for the next
> development cycle, this is the patch which I'm testing.

>                     - Ted

Hello, I've tested with your patch. But the same problem was reproduced.
Currently, I'm trying to git bisect. If i done git bisect, i will let you know.

Thanks. 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
