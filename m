Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3BULTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:19:44 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:60156 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3BULTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:19:43 -0500
Message-ID: <512602C4.1090400@synopsys.com>
Date: Thu, 21 Feb 2013 16:49:32 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] metag: copy devicetree to non-init memory
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com> <1361371929-28148-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1361371929-28148-2-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013 08:22 PM, James Hogan wrote:
> Make a copy of the device tree blob in non-init memory. It is required
> when using built-in device tree files that the platform code copies the
> blob to non-init memory prior to calling unflatten_device_tree(),
> otherwise the strings that the device tree refer to will get poisoned
> and potentially reused, breaking later reading of the device tree
> post-init (such as compatible matching in modules, debugfs, and the
> procfs interface).
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

In case you need it - Reviewed-by: Vineet Gupta <vgupta@synopsys.com>
