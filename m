Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3BFOFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:05:12 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38937 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3BFOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <CACvQF52ej3mzwRhoGO0jmZq7GLOC_KJcxF+R2O1sqQaonYWqnw@mail.gmail.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
	<20130204195458.GA27963@mtj.dyndns.org>
	<5110F5DE.6030407@gmail.com>
	<20130205185349.GF4276@mtj.dyndns.org>
	<CACvQF52ej3mzwRhoGO0jmZq7GLOC_KJcxF+R2O1sqQaonYWqnw@mail.gmail.com>
Date: Wed, 6 Feb 2013 06:05:09 -0800
X-Google-Sender-Auth: CbPMRSejGLRxQ2cAYwXjI35O45c
Message-ID: <CAOS58YOAtZTdxwof9Ar6fZ6tMJQoagOqY2nX_bCUoSLZb3cSXw@mail.gmail.com>
Subject: Re: [PATCH 02/13] workqueue: fix work_busy()
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Wed, Feb 6, 2013 at 3:42 AM, Lai Jiangshan <eag0628@gmail.com> wrote:
>> Given the advisory nature of the function, why do we care?  Is it
>> needed for later patches?
>
> Ah, yes.

Please elaborate.  Also, things like that - why the patch needs to
exist or what the benefits are - really should be in the patch
description.

Thanks.

-- 
tejun
