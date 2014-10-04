Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaJDK5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:57:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45063 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaJDK5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:57:01 -0400
Date: Sat, 4 Oct 2014 03:56:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcutorture: Remove stale test configurations
Message-ID: <20141004105653.GK5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1412307228-14001-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412307228-14001-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100410-0928-0000-0000-00000562C545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:33:48PM -0400, Pranith Kumar wrote:
> Remove rcutorture configuration files which are no longer necessary.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued for 3.19, thank you!

The --kversion argument to the .../rcutorture/bin/kvm.sh script is
not obsolete.  Would you be willing to remove it along with the
"kversion" shell variable that it controls?

							Thanx, Paul

> ---
>  .../selftests/rcutorture/configs/rcu/v0.0/CFLIST   | 14 ------
>  .../configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP           | 18 -------
>  .../configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp           | 22 ---------
>  .../configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP           | 18 -------
>  .../configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp           | 22 ---------
>  .../selftests/rcutorture/configs/rcu/v0.0/NT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v0.0/NT3-NH   | 20 --------
>  .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           | 19 --------
>  .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           | 20 --------
>  .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           | 22 ---------
>  .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           | 27 ----------
>  .../selftests/rcutorture/configs/rcu/v0.0/PT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v0.0/PT2-NH   | 22 ---------
>  .../rcutorture/configs/rcu/v0.0/ver_functions.sh   | 33 -------------
>  .../selftests/rcutorture/configs/rcu/v3.12/CFLIST  | 17 -------
>  .../configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP          | 19 --------
>  .../configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp          | 20 --------
>  .../configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp          | 22 ---------
>  .../configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP          | 18 -------
>  .../configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp          | 22 ---------
>  .../configs/rcu/v3.12/N6---t-nh-SD-smp-hp          | 19 --------
>  .../configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP          | 26 ----------
>  .../configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP          | 22 ---------
>  .../selftests/rcutorture/configs/rcu/v3.12/NT1-nh  | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.12/NT3-NH  | 20 --------
>  .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          | 20 --------
>  .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          | 20 --------
>  .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          | 20 --------
>  .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          | 22 ---------
>  .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          | 27 ----------
>  .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          | 18 -------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          | 30 ------------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      | 30 ------------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     | 30 ------------
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          | 30 ------------
>  .../selftests/rcutorture/configs/rcu/v3.12/PT1-nh  | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.12/PT2-NH  | 22 ---------
>  .../selftests/rcutorture/configs/rcu/v3.3/CFLIST   | 14 ------
>  .../configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP           | 19 --------
>  .../configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp           | 22 ---------
>  .../configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP           | 18 -------
>  .../configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp           | 22 ---------
>  .../selftests/rcutorture/configs/rcu/v3.3/NT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.3/NT3-NH   | 20 --------
>  .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           | 20 --------
>  .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           | 20 --------
>  .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           | 22 ---------
>  .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           | 27 ----------
>  .../selftests/rcutorture/configs/rcu/v3.3/PT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.3/PT2-NH   | 22 ---------
>  .../rcutorture/configs/rcu/v3.3/ver_functions.sh   | 44 -----------------
>  .../selftests/rcutorture/configs/rcu/v3.5/CFLIST   | 14 ------
>  .../configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP           | 19 --------
>  .../configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp           | 22 ---------
>  .../configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP           | 18 -------
>  .../configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp           | 22 ---------
>  .../selftests/rcutorture/configs/rcu/v3.5/NT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.5/NT3-NH   | 20 --------
>  .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           | 20 --------
>  .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           | 20 --------
>  .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           | 20 --------
>  .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           | 22 ---------
>  .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           | 27 ----------
>  .../selftests/rcutorture/configs/rcu/v3.5/PT1-nh   | 23 ---------
>  .../selftests/rcutorture/configs/rcu/v3.5/PT2-NH   | 22 ---------
>  .../rcutorture/configs/rcu/v3.5/ver_functions.sh   | 57 ----------------------
>  71 files changed, 1588 deletions(-)
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
>  delete mode 100644 tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
> 
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
> deleted file mode 100644
> index 1822394..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/CFLIST
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -P1-S-T-NH-SD-SMP-HP
> -P2-2-t-nh-sd-SMP-hp
> -P3-3-T-nh-SD-SMP-hp
> -P4-A-t-NH-sd-SMP-HP
> -P5-U-T-NH-sd-SMP-hp
> -N1-S-T-NH-SD-SMP-HP
> -N2-2-t-nh-sd-SMP-hp
> -N3-3-T-nh-SD-SMP-hp
> -N4-A-t-NH-sd-SMP-HP
> -N5-U-T-NH-sd-SMP-hp
> -PT1-nh
> -PT2-NH
> -NT1-nh
> -NT3-NH
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index d3ef873..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 02e4185..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index b3100f6..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index c56b445..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 90d924f..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/N5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
> deleted file mode 100644
> index 023f312..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
> deleted file mode 100644
> index 6fd0235..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/NT3-NH
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index dd7bd4d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 81d4843..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index 16e22b7..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index ea7ed3b..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 24f4d5e..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
> deleted file mode 100644
> index e3361c3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
> deleted file mode 100644
> index 64abfc3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/PT2-NH
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
> deleted file mode 100644
> index 5ace37a..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/ver_functions.sh
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -#!/bin/bash
> -#
> -# Kernel-version-dependent shell functions for the rest of the scripts.
> -#
> -# This program is free software; you can redistribute it and/or modify
> -# it under the terms of the GNU General Public License as published by
> -# the Free Software Foundation; either version 2 of the License, or
> -# (at your option) any later version.
> -#
> -# This program is distributed in the hope that it will be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, you can access it online at
> -# http://www.gnu.org/licenses/gpl-2.0.html.
> -#
> -# Copyright (C) IBM Corporation, 2013
> -#
> -# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> -
> -# per_version_boot_params bootparam-string config-file seconds
> -#
> -# Adds per-version torture-module parameters to kernels supporting them.
> -# Which old kernels do not.
> -per_version_boot_params () {
> -	echo	rcutorture.stat_interval=15 \
> -		rcutorture.shutdown_secs=$3 \
> -		rcutorture.rcutorture_runnable=1 \
> -		rcutorture.test_no_idle_hz=1 \
> -		rcutorture.verbose=1
> -}
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
> deleted file mode 100644
> index da4cbc66..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/CFLIST
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -sysidleY.2013.06.19a
> -sysidleN.2013.06.19a
> -P1-S-T-NH-SD-SMP-HP
> -P2-2-t-nh-sd-SMP-hp
> -P3-3-T-nh-SD-SMP-hp
> -P4-A-t-NH-sd-SMP-HP
> -P5-U-T-NH-sd-SMP-hp
> -P6---t-nh-SD-smp-hp
> -N1-S-T-NH-SD-SMP-HP
> -N2-2-t-nh-sd-SMP-hp
> -N3-3-T-nh-SD-SMP-hp
> -N4-A-t-NH-sd-SMP-HP
> -N5-U-T-NH-sd-SMP-hp
> -PT1-nh
> -PT2-NH
> -NT1-nh
> -NT3-NH
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index d81e11d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 02e4185..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index b3100f6..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index c56b445..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 90d924f..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
> deleted file mode 100644
> index 0ccc36d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N6---t-nh-SD-smp-hp
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_NR_CPUS=1
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
> deleted file mode 100644
> index 3f640cf..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N7-4-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,26 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_RCU_NOCB_CPU=y
> -CONFIG_RCU_NOCB_CPU_NONE=y
> -CONFIG_RCU_NOCB_CPU_ZERO=n
> -CONFIG_RCU_NOCB_CPU_ALL=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
> deleted file mode 100644
> index 285da2d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/N8-2-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=14
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
> deleted file mode 100644
> index 023f312..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
> deleted file mode 100644
> index 6fd0235..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/NT3-NH
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index 6880663..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 81d4843..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index 16e22b7..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index ea7ed3b..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 24f4d5e..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
> deleted file mode 100644
> index 1be59e4..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=n
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
> deleted file mode 100644
> index b49ef74..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_RCU_NOCB_CPU=y
> -CONFIG_RCU_NOCB_CPU_NONE=n
> -CONFIG_RCU_NOCB_CPU_ZERO=n
> -CONFIG_RCU_NOCB_CPU_ALL=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_SLUB=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
> deleted file mode 100644
> index a55a6ac..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_RCU_NOCB_CPU=y
> -CONFIG_RCU_NOCB_CPU_NONE=y
> -CONFIG_RCU_NOCB_CPU_ZERO=n
> -CONFIG_RCU_NOCB_CPU_ALL=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_SLUB=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
> deleted file mode 100644
> index a55a6ac..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_RCU_NOCB_CPU=y
> -CONFIG_RCU_NOCB_CPU_NONE=y
> -CONFIG_RCU_NOCB_CPU_ZERO=n
> -CONFIG_RCU_NOCB_CPU_ALL=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_SLUB=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
> deleted file mode 100644
> index 3134f46..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=16
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_RCU_NOCB_CPU=y
> -CONFIG_RCU_NOCB_CPU_NONE=n
> -CONFIG_RCU_NOCB_CPU_ZERO=y
> -CONFIG_RCU_NOCB_CPU_ALL=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_SLUB=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
> deleted file mode 100644
> index e3361c3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
> deleted file mode 100644
> index 64abfc3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/PT2-NH
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
> deleted file mode 100644
> index 1822394..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/CFLIST
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -P1-S-T-NH-SD-SMP-HP
> -P2-2-t-nh-sd-SMP-hp
> -P3-3-T-nh-SD-SMP-hp
> -P4-A-t-NH-sd-SMP-HP
> -P5-U-T-NH-sd-SMP-hp
> -N1-S-T-NH-SD-SMP-HP
> -N2-2-t-nh-sd-SMP-hp
> -N3-3-T-nh-SD-SMP-hp
> -N4-A-t-NH-sd-SMP-HP
> -N5-U-T-NH-sd-SMP-hp
> -PT1-nh
> -PT2-NH
> -NT1-nh
> -NT3-NH
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index d81e11d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 02e4185..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index b3100f6..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index c56b445..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 90d924f..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/N5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
> deleted file mode 100644
> index 023f312..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
> deleted file mode 100644
> index 6fd0235..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/NT3-NH
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index 6880663..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 81d4843..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index 16e22b7..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index ea7ed3b..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 24f4d5e..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
> deleted file mode 100644
> index e3361c3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
> deleted file mode 100644
> index 64abfc3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/PT2-NH
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
> deleted file mode 100644
> index bae5569..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/ver_functions.sh
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -#!/bin/bash
> -#
> -# Kernel-version-dependent shell functions for the rest of the scripts.
> -#
> -# This program is free software; you can redistribute it and/or modify
> -# it under the terms of the GNU General Public License as published by
> -# the Free Software Foundation; either version 2 of the License, or
> -# (at your option) any later version.
> -#
> -# This program is distributed in the hope that it will be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, you can access it online at
> -# http://www.gnu.org/licenses/gpl-2.0.html.
> -#
> -# Copyright (C) IBM Corporation, 2013
> -#
> -# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> -
> -# rcutorture_param_onoff bootparam-string config-file
> -#
> -# Adds onoff rcutorture module parameters to kernels having it.
> -rcutorture_param_onoff () {
> -	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
> -	then
> -		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
> -		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
> -	fi
> -}
> -
> -# per_version_boot_params bootparam-string config-file seconds
> -#
> -# Adds per-version torture-module parameters to kernels supporting them.
> -per_version_boot_params () {
> -	echo $1 `rcutorture_param_onoff "$1" "$2"` \
> -		rcutorture.stat_interval=15 \
> -		rcutorture.shutdown_secs=$3 \
> -		rcutorture.rcutorture_runnable=1 \
> -		rcutorture.test_no_idle_hz=1 \
> -		rcutorture.verbose=1
> -}
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
> deleted file mode 100644
> index 1822394..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/CFLIST
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -P1-S-T-NH-SD-SMP-HP
> -P2-2-t-nh-sd-SMP-hp
> -P3-3-T-nh-SD-SMP-hp
> -P4-A-t-NH-sd-SMP-HP
> -P5-U-T-NH-sd-SMP-hp
> -N1-S-T-NH-SD-SMP-HP
> -N2-2-t-nh-sd-SMP-hp
> -N3-3-T-nh-SD-SMP-hp
> -N4-A-t-NH-sd-SMP-HP
> -N5-U-T-NH-sd-SMP-hp
> -PT1-nh
> -PT2-NH
> -NT1-nh
> -NT3-NH
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index d81e11d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 02e4185..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index b3100f6..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index c56b445..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 90d924f..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/N5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -#CHECK#CONFIG_TREE_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
> deleted file mode 100644
> index 023f312..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
> deleted file mode 100644
> index 6fd0235..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/NT3-NH
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -#CHECK#CONFIG_TINY_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=y
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=n
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
> deleted file mode 100644
> index 6880663..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_RCU_FAST_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=8
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
> deleted file mode 100644
> index 81d4843..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=4
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
> deleted file mode 100644
> index 16e22b7..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
> +++ /dev/null
> @@ -1,20 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_NO_HZ=n
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=2
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
> deleted file mode 100644
> index ea7ed3b..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_RCU_TRACE=n
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=n
> -CONFIG_HOTPLUG_CPU=y
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
> deleted file mode 100644
> index 24f4d5e..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_CPU_STALL_INFO=y
> -CONFIG_NO_HZ=y
> -CONFIG_SMP=y
> -CONFIG_RCU_FANOUT=6
> -CONFIG_NR_CPUS=8
> -CONFIG_RCU_FANOUT_EXACT=y
> -CONFIG_HOTPLUG_CPU=n
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -#CHECK#CONFIG_PREEMPT_RCU=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_OBJECTS=y
> -CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> -CONFIG_RT_MUTEXES=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
> deleted file mode 100644
> index e3361c3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT1-nh
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_BOOST=y
> -CONFIG_RCU_BOOST_PRIO=2
> -CONFIG_RCU_TRACE=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=n
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
> deleted file mode 100644
> index 64abfc3..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/PT2-NH
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -CONFIG_TINY_PREEMPT_RCU=y
> -CONFIG_RCU_TORTURE_TEST=m
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_SUSPEND=n
> -CONFIG_HIBERNATION=n
> -#
> -CONFIG_SMP=n
> -#
> -CONFIG_HOTPLUG_CPU=n
> -#
> -CONFIG_NO_HZ=y
> -#
> -CONFIG_PREEMPT_NONE=n
> -CONFIG_PREEMPT_VOLUNTARY=n
> -CONFIG_PREEMPT=y
> -CONFIG_PROVE_LOCKING=y
> -CONFIG_PROVE_RCU=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_IKCONFIG=y
> -CONFIG_IKCONFIG_PROC=y
> -CONFIG_PRINTK_TIME=y
> -
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
> deleted file mode 100644
> index 8977d8d..0000000
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/ver_functions.sh
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -#!/bin/bash
> -#
> -# Kernel-version-dependent shell functions for the rest of the scripts.
> -#
> -# This program is free software; you can redistribute it and/or modify
> -# it under the terms of the GNU General Public License as published by
> -# the Free Software Foundation; either version 2 of the License, or
> -# (at your option) any later version.
> -#
> -# This program is distributed in the hope that it will be useful,
> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -# GNU General Public License for more details.
> -#
> -# You should have received a copy of the GNU General Public License
> -# along with this program; if not, you can access it online at
> -# http://www.gnu.org/licenses/gpl-2.0.html.
> -#
> -# Copyright (C) IBM Corporation, 2013
> -#
> -# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> -
> -# rcutorture_param_n_barrier_cbs bootparam-string
> -#
> -# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
> -rcutorture_param_n_barrier_cbs () {
> -	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
> -	then
> -		:
> -	else
> -		echo rcutorture.n_barrier_cbs=4
> -	fi
> -}
> -
> -# rcutorture_param_onoff bootparam-string config-file
> -#
> -# Adds onoff rcutorture module parameters to kernels having it.
> -rcutorture_param_onoff () {
> -	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
> -	then
> -		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
> -		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
> -	fi
> -}
> -
> -# per_version_boot_params bootparam-string config-file seconds
> -#
> -# Adds per-version torture-module parameters to kernels supporting them.
> -per_version_boot_params () {
> -	echo $1 `rcutorture_param_onoff "$1" "$2"` \
> -		`rcutorture_param_n_barrier_cbs "$1"` \
> -		rcutorture.stat_interval=15 \
> -		rcutorture.shutdown_secs=$3 \
> -		rcutorture.rcutorture_runnable=1 \
> -		rcutorture.test_no_idle_hz=1 \
> -		rcutorture.verbose=1
> -}
> -- 
> 1.9.1
> 

