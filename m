Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3GKWPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:15:14 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60971 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3GKWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:15:09 -0400
Date: Thu, 11 Jul 2013 15:15:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vladimir Cernov <gg.kaspersky@gmail.com>
cc: akpm@linux-foundation.org, sasha.levin@oracle.com,
        linux@rasmusvillemoes.dk, shli@fusionio.com, khlebnikov@openvz.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] madvise: fix checkpatch errors
In-Reply-To: <1373526037-9134-1-git-send-email-gg.kaspersky@gmail.com>
Message-ID: <alpine.DEB.2.02.1307111514560.2458@chino.kir.corp.google.com>
References: <1373526037-9134-1-git-send-email-gg.kaspersky@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Vladimir Cernov wrote:

> This fixes following errors:
> 	- ERROR: "(foo*)" should be "(foo *)"
> 	- ERROR: "foo ** bar" should be "foo **bar"
> 
> Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
