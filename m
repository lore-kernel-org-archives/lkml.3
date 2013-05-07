Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3EHDph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 23:45:37 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:37865 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3EHDpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 23:45:06 -0400
Date: Tue, 07 May 2013 00:02:13 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write
 (emerg_wr) config register in virtio console.
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        anup.patel@linaro.org, amit.shah@redhat.com,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
	<1367842791-30285-3-git-send-email-pranavkumar@linaro.org>
In-Reply-To: <1367842791-30285-3-git-send-email-pranavkumar@linaro.org>
	(from pranavkumar@linaro.org on Mon May  6 07:19:50 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1367902933.18069.212@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 07:19:50 AM, Pranavkumar Sawargaonkar wrote:
> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> ---
>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/virtio-spec.txt  
> b/Documentation/virtual/virtio-spec.txt
> index 0d6ec85..3ca38f8 100644
> --- a/Documentation/virtual/virtio-spec.txt
> +++ b/Documentation/virtual/virtio-spec.txt
> @@ -1927,11 +1927,16 @@ Ports 2 onwards only if  
> VIRTIO_CONSOLE_F_MULTIPORT is set
>      ports; configuration fields nr_ports and max_nr_ports are
>      valid and control virtqueues will be used.
> 
> +  VIRTIO_CONSOLE_F_EMERG_WRITE(2) Device has support for emergency
> +  write. Configuration filed emerg_wr is valid.

Emergency?

Really?

Out of morbid curiosity, what would constitute an _emergency_ in a  
virtual machine logging context?

Rob