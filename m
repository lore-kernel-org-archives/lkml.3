Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab3D0CYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 22:24:30 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:33068 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3D0CY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 22:24:28 -0400
MIME-Version: 1.0
In-Reply-To: <7vvc78u8jl.fsf@alter.siamese.dyndns.org>
References: <7vvc78u8jl.fsf@alter.siamese.dyndns.org>
From: shawn wilson <ag4ve.us@gmail.com>
Date: Fri, 26 Apr 2013 22:24:07 -0400
Message-ID: <CAH_OBievcf-_z_AX9UrmWL_HVFT2vSQTu+wXAjAFeQBM8iFSGw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git v1.8.3-rc0
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 8:22 PM, Junio C Hamano <gitster@pobox.com> wrote:

>  * There was no good way to ask "I have a random string that came from
>    outside world. I want to turn it into a 40-hex object name while
>    making sure such an object exists".  A new peeling suffix ^{object}
>    can be used for that purpose, together with "rev-parse --verify".
>

What does this mean / what is the reason behind this? I can only think
it might be useful in a test suite to make sure git isn't doing
anything stupid with hashes...?
