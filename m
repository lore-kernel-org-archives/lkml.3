Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaI3GCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:02:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34530 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3GCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:02:00 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-c2-542a474fcdd9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/3] f2fs: introduce cp_control structure
Date: Tue, 30 Sep 2014 14:01:09 +0800
Message-id: <005f01cfdc74$081ba420$1852ec60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJfDGgbbMp3eCh6ndgph+iyAEGBoZr5Wtug
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jQd0Ad60Qgykz2S2erJ/FbHFpkbvF
	5V1z2ByYPTat6mTz2L3gM5PH501yAcxRXDYpqTmZZalF+nYJXBl/z35nLXjKUrFm8T3GBsZG
	li5GTg4JAROJ+deWsEHYYhIX7q0Hsrk4hASmM0p8ePkarEhI4AejxI8N+iA2m4CKxPKO/0wg
	toiAmkTvvilANgcHs4CHxK5jpRDlThLfbu1kBbE5BZwlGv99ARsjDFTyp/s92C4WAVWJtY1r
	wGxeAUuJF3+3MkHYghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmiDsVJHacfc0IcYKRxP6rcxgh
	asQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	B/sz6R2MqxosDjEKcDAq8fByyGuFCLEmlhVX5h5ilOBgVhLhVTMHCvGmJFZWpRblxxeV5qQW
	H2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamCcWGBpGlsxg52t49kt2R4ZueS16/K8
	Q/6eF1ouWmX8TOjZ7glzHhTqr5t859vTfQpdotlaiYZvHwlLbhE0uNG14GeeJQdvjMQP00Nl
	9T4HQyewRgaFf9jOvowv2HDrxVj+1hjjv5ou82JbuQpeWWib3OGNE55Wbsbh52Gr25kmW7L4
	SPr/qUosxRmJhlrMRcWJAN/0zBVyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, September 23, 2014 12:53 PM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/3] f2fs: introduce cp_control structure
> 
> This patch add a new data structure to control checkpoint parameters.
> Currently, it presents the reason of checkpoint such as is_umount and normal
> sync.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Looks good!

Reviewed-by: Chao Yu <chao2.yu@samsung.com>


