Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3AaSvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:51:54 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36001 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab3AaSvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:51:46 -0500
Date: Thu, 31 Jan 2013 04:19:55 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 1/3] Documentation: update seq_file
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20130130012946.GB20174@altlinux.org>
In-Reply-To: <20130130012946.GB20174@altlinux.org> (from ldv@altlinux.org on
	Tue Jan 29 19:29:47 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1359627595.12062.0@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 07:29:47 PM, Dmitry V. Levin wrote:
> Starting with commit v3.2-rc4-1-g02125a8, seq_path_root() no longer
> changes the value of root.
> Starting with commit v3.2-rc7-104-g8c9379e, some arguments of  
> seq_path()
> and seq_path_root() are const.
> 
> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>

Acked-by: Rob Landley <rob@landley.net>

Rob