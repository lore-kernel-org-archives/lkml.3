Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaHIWvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 18:51:04 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:59739 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaHIWvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 18:51:02 -0400
Date: Sun, 10 Aug 2014 01:50:53 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Junien Fridrick <linux.kernel@junien.fridrick.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Siyao <lai.siyao@intel.com>, Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next-20140808] [staging] [lustre] Fix coding style in
 llite/remote_perm.c
Message-ID: <20140809225053.GA4053@drone.musicnaut.iki.fi>
References: <1407615768-6757-1-git-send-email-linux.kernel@junien.fridrick.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407615768-6757-1-git-send-email-linux.kernel@junien.fridrick.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:22:48PM +0000, Junien Fridrick wrote:
> Sorry for the noise, this is part of task 10 of the Eudyptula Challenge.

Nothing wrong with the patch itself, but maybe in the future you could
put such comments after the "---" line so that they won't be included
in the git commit logs when the patch is applied (and will end
up being "noise").

A.
