Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaE0UkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:40:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29294 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaE0UkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:40:23 -0400
Date: Tue, 27 May 2014 23:39:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaitanya Hazarey <c@24.io>
Cc: gregkh@linuxfoundation.org, andrea.merello@gmail.com,
        linville@tuxdriver.com, burzalodowa@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Staging: rtl8192u: r8180_93cx6.c & r8192U_wx.c fix
 checkpatch.pl errors and warnings
Message-ID: <20140527203956.GO15585@mwanda>
References: <1401221390-10655-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401221390-10655-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 01:09:45PM -0700, Chaitanya Hazarey wrote:
> Fixed the following:
> 
> ERROR: do not use C99 // comments
> ERROR: space required after that ',' (ctx:VxV)
> ERROR: space required after that ';' (ctx:VxV)
> ERROR: space required before the open brace '{'
> ERROR: spaces required around that '=' (ctx:VxV)
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: space required after that close brace '}'
> ERROR: spaces required around that '==' (ctx:VxV)
> ERROR: space required before the open parenthesis '('
> 

All of these patches have the same subject.  And also they aren't
broken up in the correct way.  Basically for this kind of thing we want
to see one kind of cleanup per patch.

[patch 1/6] Staging: rtl8192u: add missing spaces
[patch 2/6] Staging: rtl8192u: delete commented out code
[patch 3/6] Staging: rtl8192u: clean up c99 comments
[patch 4/6] Staging: rtl8192u: reformat long lines
...

Etc.

Sorry for asking people to redo these again...

regards,
dan carpenter

