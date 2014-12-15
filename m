Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaLOR6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:58:15 -0500
Received: from mx02.posteo.de ([89.146.194.165]:52136 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaLOR6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:58:09 -0500
Message-ID: <548F212C.3070300@posteo.de>
Date: Mon, 15 Dec 2014 18:58:04 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: peterz@infradead.org
CC: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] bitops.h: add sign_extend16 function
References: <1418660317-21750-1-git-send-email-martink@posteo.de> <1418660317-21750-3-git-send-email-martink@posteo.de>
In-Reply-To: <1418660317-21750-3-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-12-15 um 17:18 schrieb Martin Kepplinger:
> This adds sign_exten16 to sign extend any signed value shorter than 16 bits
> to a s16.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
if you feel motivated, you can add this to the commit message:

Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>

