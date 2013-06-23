Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3FWH6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:58:22 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:51331 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3FWH6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:58:17 -0400
Date: Sun, 23 Jun 2013 10:58:08 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Gustavo Padovan <gustavo@padovan.org>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-06-23
Message-ID: <20130623075808.GA1495@x220.P-661HNU-F1>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130623021351.GA2327@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623021351.GA2327@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 23, 2013, Gustavo Padovan wrote:
> A important fix to 3.10, this patch fixes an issues that was preventing the 
> l2cap info response command to be handled properly. Please pull. Thanks!

I'd like to add here (since it's not obvious) that this is not just
about failing to parse the L2CAP info response. Once the code gives up
parsing this PDU it also gives up essential parts of the L2CAP
connection creation process, i.e. without this patch the stack will fail
to establish connections properly. So it'd be very good if we can get
this into 3.10 (as well as the stable trees where the patch that
introduced this bug is already on its way).

Johan
