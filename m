Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967691Ab3HIDSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:18:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46415 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967411Ab3HIDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:18:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-f9-52045f716f77
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Chris Ball'" <cjb@laptop.org>, "'Olof Johansson'" <olof@lixom.net>
Cc: "'Doug Anderson'" <dianders@google.com>,
        "'James Hogan'" <james.hogan@imgtec.com>, linux-mmc@vger.kernel.org,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Sonny Rao'" <sonnyrao@chromium.org>
References: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
 <CAOesGMjaF2K0CnuWBj7xdXGAQk-XRetBstaQdd9EZzBYrmDjeA@mail.gmail.com>
 <86mworfzsf.fsf@void.printf.net>
In-reply-to: <86mworfzsf.fsf@void.printf.net>
Subject: RE: dw_mmc: Does anyone use multiple slots?
Date: Fri, 09 Aug 2013 12:18:07 +0900
Message-id: <000e01ce94af$12710ef0$37532cd0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6Um0US6te59YX/QUmdHh+Gu98lVAAAwi7g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zY93CeJYggyk3eC0er1nMZPFg3jY2
	i+2vN7JZnF12kM1iwfaVTBavjvxgsng37wWzxY1fbawWvQuusllsenyN1eLyrjlsFkf+9zNa
	zDi/j8ni1PXPbBZPzsxktFi16w+jg4DH7IaLLB47Z91l91iwqdSjZ+cZRo9DV9YyemxeUu9x
	5UQTq0ffllWMHp83yQVwRnHZpKTmZJalFunbJXBl9B68yFxwg7tie/8x9gbGSZxdjJwcEgIm
	EtsOnGOCsMUkLtxbz9bFyMUhJLCMUeLLz30sMEXTt/exQCSmM0o8+f0NquoPo0TD7LNg7WwC
	WhJ/37xhBrFFBFwkll/7zQpSxCxwkEXiTHcvVPseRokF6+aCVXEK6Eos/X6KEcQWBtrxddc/
	sEksAqoSlx98ZwWxeQVsJa59fsEMYQtK/Jh8D+wmZgEDifez+lghbHmJzWveAtVwAN2qLvHo
	ry7EEUYSF39cZIMoEZHY9+IdI8gNEgJnOCS2tN9hhNglIPFt8iEWiF5ZiU0HmCFelpQ4uOIG
	ywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMkgfTtYLx5
	wPoQYzLQ+onMUqLJ+cAElFcSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGRonirWFZR8WkVcsMbm+2vjBB7rjmWmtOS6NFdg3yT489aN+cJPhulzpb
	wdEfS465zJjsO/Vj+z2fk27r166fe6Zn8stfr8qML15Z86FHeent6zGXv+j3hE9+fu4np469
	/u4bZp9aLf4uVuMUZP3swXqvIbu3a3rcsYjmL52z55049uz2nKXLJb8rsRRnJBpqMRcVJwIA
	3b/PVzYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xoG5hPEuQwbMH7BaP1yxmsngwbxub
	xfbXG9kszi47yGaxYPtKJotXR34wWbyb94LZ4savNlaL3gVX2Sw2Pb7GanF51xw2iyP/+xkt
	Zpzfx2Rx6vpnNosnZ2YyWqza9YfRQcBjdsNFFo+ds+6yeyzYVOrRs/MMo8ehK2sZPTYvqfe4
	cqKJ1aNvyypGj8+b5AI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOA3lBSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvQe
	vMhccIO7Ynv/MfYGxkmcXYycHBICJhLTt/exQNhiEhfurWfrYuTiEBKYzijx5Pc3KOcPo0TD
	7LNMIFVsAloSf9+8YQaxRQRcJJZf+80KUsQscJBF4kx3LwtExx5GiQXr5oJVcQroSiz9fooR
	xBYG2vd11z+wSSwCqhKXH3xnBbF5BWwlrn1+wQxhC0r8mHwP7CZmAQOJ97P6WCFseYnNa94C
	1XAA3aou8eivLsQRRhIXf1xkgygRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEZyenknvYFzVYHGIUYCDUYmHV3E7c5AQa2JZcWXuIUYJDmYl
	Ed4XWUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgemzrySeENjEzMjSyMzCyMTc3PShJXE
	eQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYFz5W9ekknmvyoTY29HXj2lvSdsvxmd7smO9m9e0
	8zXH9EWeOX5e+KN4yjLhtt/i7BOuv93hVrP8wrJnK2oerbB9dWr3wlmtDc33c0zdNK++Yz2v
	K315xqZ2MSXrn5dPZLpMK7TifxduKMpzuOY3a9jzJSo9t+cwXRMOdOjTDJXU3S/8flfhFXUl
	luKMREMt5qLiRAAGoUHHkwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 09, 2013, Chris Ball wrote:
> On Fri, Aug 09 2013, Olof Johansson wrote:
> > On Thu, Aug 8, 2013 at 5:16 PM, Doug Anderson <dianders@google.com> wrote:
> >
> >> I guess my overall question is: if there are no actual implementations
> >> of multislot, shouldn't we kill it and simplify the code a whole lot?
> >> If someone out there has a real multislot device they can step back in
> >> and do it more correctly?
> >>
> >> Of course we need to find someone to actually go through and do the
> >> killing of multislot, but finding that person might be easier if there
> >> was some agreement that it was good to do.
> >
> > There clearly seems to be no in-tree users of multislot. If someone
> > new comes in, we have the code in the history and can revert the
> > removal (or at least use it as reference for re-introduction).
> >
> > I vote for removing it. It adds really annoying complexity for
> > something that nobody uses.
> 
> I agree with Olof, for what it's worth.  (The maintainers of the
> driver are Jaehoon and Seungwon, though.)

I feel like there is no actual use case for that though origin Synopsys IP supports.
Multi-slot  might be not useful in terms of performance because shared bus should be allowed.
(At least this is the way I see it, though)
As Exynos's host does so, other hosts which are introduced in Linux seems use one card per host.
If it's really not found now, I could agree on this topic.

Thanks,
Seungwon Jeon

