Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3A1IJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:09:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56295 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3A1IJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:09:52 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-99-5106324d9135
Message-id: <51063248.5010800@samsung.com>
Date: Mon, 28 Jan 2013 09:09:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Provide dma_mmap_coherent() and dma_get_sgtable()
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdU=4+AZDTHABzwkEEeDQNtMZfWgb23Tf1f1befofGMcQQ@mail.gmail.com>
In-reply-to: <CAMuHMdU=4+AZDTHABzwkEEeDQNtMZfWgb23Tf1f1befofGMcQQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4ZV1fI7ZAg857FhYdu76yWFzeNYfN
	gcnj8ya5AMYoLpuU1JzMstQifbsErown266xFkxkqdg97RJLA+Ns5i5GTg4JAROJ/k/f2SFs
	MYkL99azgdhCAksZJQ7ujepi5AKym5kk+j/3sIIkeAW0JM6/mA/UwMHBIqAqcfKKP0iYTcBQ
	outtF1ivqECoxNp9a5ghygUlfky+xwJSLiKgKzHnJxNImFnARuJI935GkLCwgK/ElAdeEJu6
	GSW+bV0K1sopECwx4fNkRoh6M4lHLeuYIWx5ic1r3jJPYBSYhWTDLCRls5CULWBkXsUomlqa
	XFCclJ5rqFecmFtcmpeul5yfu4kREoZfdjAuPmZ1iFGAg1GJh/dnGkugEGtiWXFl7iFGCQ5m
	JRHemDOsgUK8KYmVValF+fFFpTmpxYcYmTg4pRoYNZT06z9wfduoK56/NSb165Q9H9p0cu/1
	5zp+2tArOEX5tqGq6twTihK7dxkc+rEstYtx/qf/GSf/XTQKnvlmiTPz3y3amn/ENITbTCPk
	THod43foOwmvYn7Wrh74a51wR8wpp79lUifbKjt6TvNtyOoySJtroHXQ/er+YzUmepslliV+
	CGpUYinOSDTUYi4qTgQA37ZuBiECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 1/27/2013 11:43 AM, Geert Uytterhoeven wrote:
> On Sun, Jan 27, 2013 at 11:33 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > I'll add this to the m68k for-next branch, so hopefully we can get an
> > unbroken build in 3.8.
>
> Sorry, I meant "for-linus", as it's destined for 3.8, not 3.9.

Do you want me to take those patches via dma-mapping tree or get my ack
and put them together with your other m68k fixes for v3.8?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


