Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaI1IiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaI1Ih7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:37:59 -0400
Date: Sun, 28 Sep 2014 10:35:32 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Denis Kirjanov <kda@linux-powerpc.org>
Cc: Nicholas Krause <yocto6@gmail.com>, IvDoorn@gmail.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, linux-kernel@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH] wireless: Remove unnessary write over of
 register 11 in rt2800lib.c
Message-ID: <20140928083531.GA2013@redhat.com>
References: <1411852301-26857-1-git-send-email-yocto6@gmail.com>
 <20140928070923.GA2087@redhat.com>
 <CAOJe8K1nkeVjNpNoUBxuJv-YXj3Wr_oH86yR31U7w3Jq5j7oxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJe8K1nkeVjNpNoUBxuJv-YXj3Wr_oH86yR31U7w3Jq5j7oxw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 12:05:30PM +0400, Denis Kirjanov wrote:
> Or someone with the hardware has to test and check that...

... on all possible combinations of channel, bandwidth, signal strength, modulation type, ...

Stanislaw

