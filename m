Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaJPXcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 19:32:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53151 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaJPXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 19:32:38 -0400
X-AuditID: cbfee68f-f791c6d000004834-da-5440558a8f8d
Message-id: <5440558A.3080202@samsung.com>
Date: Fri, 17 Oct 2014 08:32:26 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH] extcon: Implement OF-based extcon lookup properly
References: <1413465104-26201-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1413465104-26201-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSotsV6hBi8GQTt8XlXXPYLNYeuctu
	cbtxBZvFql1/GB1YPHbOusvu0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBlbPi5kKuhlq7j/
	YQpbA2MLaxcjJ4eEgIlE88TfbBC2mMSFe+uBbC4OIYGljBKXn/5ggymavPwmM0RiOqPE28er
	2SGc14wSSy/sAhvFK6Al0b5sIpjNIqAqMenAIiYQmw0ovv/FDbBJogJhEiunX2GBqBeU+DH5
	HpgtIqAv0d12hRHEZhYokDi18DgziC0s4CaxvqmdHcQWEvCQuLHwI5jNKeApcXHTEah6HYn9
	rdPYIGx5ic1r3oJdKiGwiF3i+6Un7BAHCUh8m3wIaBkHUEJWYtMBZojPJCUOrrjBMoFRbBaS
	k2YhGTsLydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQLj6PS/Z/07GO8esD7EKMDB
	qMTDqxFsHyLEmlhWXJl7iNEU6IqJzFKiyfnAaM0riTc0NjOyMDUxNTYytzRTEuddKPUzWEgg
	PbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjCam69duLbroaeAftXsKXrPe6lWPv/guea+foKWws
	SrZU2vA5rVmh400QD+dB9evb1vRmarBvMut3E9yhIrDoA1ek8oLQVNOkBXXdYhre0/Y82ix2
	z/3D1IpnySvXf9Rcvut5fqWAScSS9vJfv/69999775w9T97a99rN+2+s8qitSj+ox39CiaU4
	I9FQi7moOBEADrMGTZ4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jQd2uUIcQg6vbWCwu75rDZrH2yF12
	i9uNK9gsVu36w+jA4rFz1l12j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM2PJxIVNBL1vF/Q9T2BoYW1i7GDk5JARMJCYvv8kMYYtJXLi3nq2LkYtD
	SGA6o8Tbx6vZIZzXjBJLL+wC6+AV0JJoXzYRzGYRUJWYdGARE4jNBhTf/+IGG4gtKhAmsXL6
	FRaIekGJH5PvgdkiAvoS3W1XGEFsZoECiVMLj4NtFhZwk1jf1M4OYgsJeEjcWPgRzOYU8JS4
	uOkIVL2OxP7WaWwQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7N
	S9dLzs/dxAiO0mdSOxhXNlgcYhTgYFTi4dUItg8RYk0sK67MPcQowcGsJML7XMMhRIg3JbGy
	KrUoP76oNCe1+BCjKTAEJjJLiSbnAxNIXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs
	1NSC1CKYPiYOTqkGxhM7X86rYX6oOYfb5eARYxXetP3mujdP8nq/vB8sfXZ5kBTv99i1PRar
	F7Azcc4r4/2YnG+yxMGhwElLIOtS8V/hucZCGgzrzocfvusTe6l0mrSj2ZY9jy4e0TIUUHu0
	NyTCNkqCN7U8dsXT/7stjmyOfisWHbl347oF+04IN7OelrAv23bwtRJLcUaioRZzUXEiAJrT
	AuboAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 10:11 PM, Marek Szyprowski wrote:
> From: Tomasz Figa <tomasz.figa@gmail.com>
> 
> Platform bus is not the only way to have extcon devices, so current
> implementation of of_extcon_get_extcon_dev() is broken. Also using
> parent device node only to get device name is quite ugly.
> 
> This patch reimplements of_extcon_get_extcon_dev() to do exactly the
> same as extcon_get_extcon_dev() but instead of comparing names, compare
> node pointers.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> [mszyprow: simplified the code]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-class.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)

Applied it. Thank you.

Chanwoo Choi

