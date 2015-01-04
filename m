Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbbADQry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:47:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbbADQrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:47:53 -0500
Date: Sun, 4 Jan 2015 16:57:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rt2x00: use helper to check
 capability/requirement
Message-ID: <20150104155740.GA6764@redhat.com>
References: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 04:19:18PM +0800, Fred Chou wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> Use rt2x00_has_cap_flag macro to check rt2x00dev->cap_flags. 
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

