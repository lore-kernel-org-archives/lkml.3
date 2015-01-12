Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbbALE5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 23:57:43 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:38840 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbALE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 23:57:40 -0500
Date: Sun, 11 Jan 2015 20:57:36 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Julian Brost <linux-kernel@0x4a42.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: Re: [PATCH 0/4] Documentation/misc-devices/mei: Fix formatting
Message-ID: <20150112045736.GB19607@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Julian Brost <linux-kernel@0x4a42.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net,
	tomas.winkler@intel.com, linux-mei@linux.intel.com,
	linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julian,

On Mon, Jan 12, 2015 at 12:58:05AM +0100, Julian Brost wrote:
> This patch series fixes multiple formatting issues in the documentation for the
> Intel MEI, including improperly formatted headlines and issues with spacing and
> indentation.
> 
> Julian Brost (4):
>   Documentation/misc-devices/mei: Fix formatting of headings.
>   Documentation/misc-devices/mei: Fix spacing around parentheses.
>   Documentation/misc-devices/mei: Fix indentation of enumeration.
>   Documentation/misc-devices/mei: Fix indentation of embedded code.
> 
>  Documentation/misc-devices/mei/mei-client-bus.txt |  17 +--
>  Documentation/misc-devices/mei/mei.txt            | 126 ++++++++++++----------
>  2 files changed, 77 insertions(+), 66 deletions(-)
> 
> -- 
> 2.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Series looks good.

I'm glad I am not the only one with OCD around here :-)

Reviewed-by: Jeremiah Mahler <jmmahler@gmail.com>

-- 
- Jeremiah Mahler
