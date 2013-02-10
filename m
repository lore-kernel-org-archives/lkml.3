Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3BJRa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 12:30:58 -0500
Received: from mail.southpole.se ([37.247.8.11]:48953 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3BJRa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 12:30:56 -0500
Message-ID: <5117D95F.2030904@southpole.se>
Date: Sun, 10 Feb 2013 18:31:11 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [ORLinux] [PATCH 13/16] openrisc idle: delete pm_idle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <06f69fdb400f9850337c1f23a1dabca0a2c39cbb.1360475150.git.len.brown@intel.com>
In-Reply-To: <06f69fdb400f9850337c1f23a1dabca0a2c39cbb.1360475150.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 17455-02173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/13 06:58, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
>
> pm_idle() on openrisc was dead code.
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: linux@lists.openrisc.net
> ---
>   arch/openrisc/kernel/idle.c | 5 -----
>   1 file changed, 5 deletions(-)

Thanks, Len.  Will apply.
/Jonas

> diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
> index 7d618fe..5e8a3b6 100644
> --- a/arch/openrisc/kernel/idle.c
> +++ b/arch/openrisc/kernel/idle.c
> @@ -39,11 +39,6 @@
>   
>   void (*powersave) (void) = NULL;
>   
> -static inline void pm_idle(void)
> -{
> -	barrier();
> -}
> -
>   void cpu_idle(void)
>   {
>   	set_thread_flag(TIF_POLLING_NRFLAG);

