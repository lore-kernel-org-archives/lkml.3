Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaKMJJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:09:37 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:32876 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753709AbaKMJJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:09:35 -0500
Message-ID: <54647543.50902@daenzer.net>
Date: Thu, 13 Nov 2014 18:09:23 +0900
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:32.0) Gecko/20100101 Icedove/32.0
MIME-Version: 1.0
To: Marcus Overhagen <marcus.overhagen@gmail.com>
CC: dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Crash of radeon_ttm_tt_unpopulate in ttm_dma_unpopulate with
References: <CAJBHPoiYce87At_DKiGbj6WnkcuuS0zEdGvdaYTDUUcq2gn6AA@mail.gmail.com>
In-Reply-To: <CAJBHPoiYce87At_DKiGbj6WnkcuuS0zEdGvdaYTDUUcq2gn6AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.11.2014 02:54, Marcus Overhagen wrote:
> This crash occured after about a day  with 3.18.0-rc3

Is it a regression? If yes, can you bisect?


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
