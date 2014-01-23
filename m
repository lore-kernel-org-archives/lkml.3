Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaAWWoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:44:10 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48450 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaAWWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:44:06 -0500
Date: Fri, 24 Jan 2014 04:14:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chad Williamson <chad@dahc.us>, Al Viro <viro@zeniv.linux.org.uk>,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>,
        devel@driverdev.osuosl.org, josh@joshtriplett.org
Subject: [PATCH] drivers: staging: Mark functions as static and remove unused
 function in bpctl_mod.c
Message-ID: <20140123224400.GA8124@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in bpctl_mod.c because they are not used
outside this file. Remove unused function from bpctl_mod.c.

This also eliminates the following warnings from bpctl_mod.c:
drivers/staging/silicom/bpctl_mod.c:1507:6: warning: no previous prototype for ‘send_bypass_clear_pulse’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1762:5: warning: no previous prototype for ‘cmnd_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1779:5: warning: no previous prototype for ‘cmnd_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1797:5: warning: no previous prototype for ‘bypass_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1818:5: warning: no previous prototype for ‘bypass_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1841:5: warning: no previous prototype for ‘tap_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1854:5: warning: no previous prototype for ‘tap_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1867:5: warning: no previous prototype for ‘disc_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1879:5: warning: no previous prototype for ‘disc_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1891:5: warning: no previous prototype for ‘disc_port_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1916:5: warning: no previous prototype for ‘disc_port_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1941:5: warning: no previous prototype for ‘tpl_hw_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1969:5: warning: no previous prototype for ‘tpl_hw_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:1995:5: warning: no previous prototype for ‘wdt_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2018:5: warning: no previous prototype for ‘wdt_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2070:6: warning: no previous prototype for ‘bp75_put_hw_semaphore_generic’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2081:5: warning: no previous prototype for ‘bp75_get_hw_semaphore_generic’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2195:5: warning: no previous prototype for ‘bp75_read_phy_reg_mdic’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2228:5: warning: no previous prototype for ‘bp75_write_phy_reg_mdic’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2539:5: warning: no previous prototype for ‘reset_cont’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2556:5: warning: no previous prototype for ‘dis_bypass_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2575:5: warning: no previous prototype for ‘en_bypass_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2591:5: warning: no previous prototype for ‘bypass_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2605:5: warning: no previous prototype for ‘normal_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2620:5: warning: no previous prototype for ‘bypass_state_pwroff’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2631:5: warning: no previous prototype for ‘normal_state_pwroff’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2642:5: warning: no previous prototype for ‘tap_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2653:5: warning: no previous prototype for ‘dis_tap_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2664:5: warning: no previous prototype for ‘en_tap_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2675:5: warning: no previous prototype for ‘disc_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2688:5: warning: no previous prototype for ‘dis_disc_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2701:5: warning: no previous prototype for ‘disc_port_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2727:5: warning: no previous prototype for ‘normal_port_state_pwron’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2753:5: warning: no previous prototype for ‘en_disc_cap’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2765:5: warning: no previous prototype for ‘std_nic_on’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2819:5: warning: no previous prototype for ‘std_nic_off’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2982:5: warning: no previous prototype for ‘bp_wait_at_pwup_en’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:2997:5: warning: no previous prototype for ‘bp_wait_at_pwup_dis’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3014:5: warning: no previous prototype for ‘bp_hw_reset_en’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3030:5: warning: no previous prototype for ‘bp_hw_reset_dis’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3045:5: warning: no previous prototype for ‘wdt_exp_mode’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3096:5: warning: no previous prototype for ‘bypass_fw_ver’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3104:5: warning: no previous prototype for ‘bypass_sign_check’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3215:5: warning: no previous prototype for ‘bypass_from_last_read’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3235:5: warning: no previous prototype for ‘bypass_status_clear’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3249:5: warning: no previous prototype for ‘bypass_flag_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3262:5: warning: no previous prototype for ‘bypass_flag_status_clear’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3277:5: warning: no previous prototype for ‘bypass_change_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3296:5: warning: no previous prototype for ‘bypass_off_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3391:5: warning: no previous prototype for ‘default_pwron_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3423:5: warning: no previous prototype for ‘dis_bypass_cap_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3436:5: warning: no previous prototype for ‘cmd_en_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3448:5: warning: no previous prototype for ‘wdt_en_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3460:5: warning: no previous prototype for ‘wdt_programmed’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3486:5: warning: no previous prototype for ‘bypass_support’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3503:5: warning: no previous prototype for ‘tap_support’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3519:5: warning: no previous prototype for ‘normal_support’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3535:5: warning: no previous prototype for ‘get_bp_prod_caps’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3544:5: warning: no previous prototype for ‘tap_flag_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3556:5: warning: no previous prototype for ‘tap_flag_status_clear’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3570:5: warning: no previous prototype for ‘tap_change_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3587:5: warning: no previous prototype for ‘tap_off_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3597:5: warning: no previous prototype for ‘tap_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3636:5: warning: no previous prototype for ‘default_pwron_tap_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3647:5: warning: no previous prototype for ‘dis_tap_cap_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3658:5: warning: no previous prototype for ‘disc_flag_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3670:5: warning: no previous prototype for ‘disc_flag_status_clear’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3684:5: warning: no previous prototype for ‘disc_change_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3695:5: warning: no previous prototype for ‘disc_off_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3791:5: warning: no previous prototype for ‘default_pwron_disc_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3802:5: warning: no previous prototype for ‘dis_disc_cap_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3813:5: warning: no previous prototype for ‘disc_port_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3837:5: warning: no previous prototype for ‘default_pwron_disc_port_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3861:5: warning: no previous prototype for ‘wdt_exp_mode_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3884:5: warning: no previous prototype for ‘tpl2_flag_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3895:5: warning: no previous prototype for ‘tpl_hw_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3910:5: warning: no previous prototype for ‘bp_wait_at_pwup_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3921:5: warning: no previous prototype for ‘bp_hw_reset_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3935:5: warning: no previous prototype for ‘std_nic_status’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:3983:6: warning: no previous prototype for ‘bypass_caps_init’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4201:5: warning: no previous prototype for ‘bypass_off_init’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4217:6: warning: no previous prototype for ‘remove_bypass_wd_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4246:5: warning: no previous prototype for ‘init_bypass_wd_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4293:5: warning: no previous prototype for ‘set_bypass_wd_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4312:5: warning: no previous prototype for ‘get_bypass_wd_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4383:5: warning: no previous prototype for ‘set_bypass_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4401:5: warning: no previous prototype for ‘get_bypass_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4406:5: warning: no previous prototype for ‘get_bypass_change_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4414:5: warning: no previous prototype for ‘set_dis_bypass_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4433:5: warning: no previous prototype for ‘get_dis_bypass_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4441:5: warning: no previous prototype for ‘set_bypass_pwoff_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4460:5: warning: no previous prototype for ‘get_bypass_pwoff_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4468:5: warning: no previous prototype for ‘set_bypass_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4487:5: warning: no previous prototype for ‘get_bypass_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4495:5: warning: no previous prototype for ‘set_bypass_wd_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4517:5: warning: no previous prototype for ‘get_bypass_wd_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4525:5: warning: no previous prototype for ‘get_wd_expire_time_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4533:5: warning: no previous prototype for ‘reset_bypass_wd_timer_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4541:5: warning: no previous prototype for ‘get_wd_set_caps_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4565:5: warning: no previous prototype for ‘set_std_nic_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4585:5: warning: no previous prototype for ‘get_std_nic_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4593:5: warning: no previous prototype for ‘set_tap_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4609:5: warning: no previous prototype for ‘get_tap_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4617:5: warning: no previous prototype for ‘set_tap_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4635:5: warning: no previous prototype for ‘get_tap_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4647:5: warning: no previous prototype for ‘get_tap_change_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4655:5: warning: no previous prototype for ‘set_dis_tap_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4672:5: warning: no previous prototype for ‘get_dis_tap_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4680:5: warning: no previous prototype for ‘set_disc_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4697:5: warning: no previous prototype for ‘get_disc_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4708:5: warning: no previous prototype for ‘set_disc_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4726:5: warning: no previous prototype for ‘get_disc_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4736:5: warning: no previous prototype for ‘get_disc_change_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4746:5: warning: no previous prototype for ‘set_dis_disc_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4764:5: warning: no previous prototype for ‘get_dis_disc_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4775:5: warning: no previous prototype for ‘set_disc_port_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4789:5: warning: no previous prototype for ‘get_disc_port_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4797:5: warning: no previous prototype for ‘set_disc_port_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4811:5: warning: no previous prototype for ‘get_disc_port_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4823:5: warning: no previous prototype for ‘get_wd_exp_mode_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4831:5: warning: no previous prototype for ‘set_wd_exp_mode_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4839:5: warning: no previous prototype for ‘reset_cont_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4851:5: warning: no previous prototype for ‘set_tx_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4872:5: warning: no previous prototype for ‘set_bp_force_link_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4884:5: warning: no previous prototype for ‘set_wd_autoreset_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4892:5: warning: no previous prototype for ‘get_wd_autoreset_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4919:5: warning: no previous prototype for ‘get_bypass_caps_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4928:5: warning: no previous prototype for ‘get_bypass_slave_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4960:5: warning: no previous prototype for ‘is_bypass’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4971:5: warning: no previous prototype for ‘get_tx_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:4991:5: warning: no previous prototype for ‘get_bp_force_link_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5054:6: warning: no previous prototype for ‘remove_bypass_tpl_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5072:5: warning: no previous prototype for ‘init_bypass_tpl_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5085:5: warning: no previous prototype for ‘set_bypass_tpl_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5103:5: warning: no previous prototype for ‘get_bypass_tpl_auto’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5113:5: warning: no previous prototype for ‘set_tpl_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5143:5: warning: no previous prototype for ‘get_tpl_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5157:5: warning: no previous prototype for ‘set_bp_wait_at_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5177:5: warning: no previous prototype for ‘get_bp_wait_at_pwup_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5190:5: warning: no previous prototype for ‘set_bp_hw_reset_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5210:5: warning: no previous prototype for ‘get_bp_hw_reset_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:5225:5: warning: no previous prototype for ‘get_bypass_info_fn’ [-Wmissing-prototypes]
drivers/staging/silicom/bpctl_mod.c:7027:5: warning: no previous prototype for ‘reset_cont_sd’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c |  584 ++++++++---------------------------
 1 file changed, 126 insertions(+), 458 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 39dc92a..a99c72b 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -1504,7 +1504,8 @@ static int send_wdt_pulse(struct bpctl_dev *pbpctl_dev)
 	return 0;
 }
 
-void send_bypass_clear_pulse(struct bpctl_dev *pbpctl_dev, unsigned int value)
+static void send_bypass_clear_pulse(struct bpctl_dev *pbpctl_dev,
+				    unsigned int value)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1759,7 +1760,7 @@ static int wdt_pulse_int(struct bpctl_dev *pbpctl_dev)
 /*************************************/
 
 /* CMND_ON  0x4 (100)*/
-int cmnd_on(struct bpctl_dev *pbpctl_dev)
+static int cmnd_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1776,7 +1777,7 @@ int cmnd_on(struct bpctl_dev *pbpctl_dev)
 }
 
 /* CMND_OFF  0x2 (10)*/
-int cmnd_off(struct bpctl_dev *pbpctl_dev)
+static int cmnd_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1794,7 +1795,7 @@ int cmnd_off(struct bpctl_dev *pbpctl_dev)
 }
 
 /* BYPASS_ON (0xa)*/
-int bypass_on(struct bpctl_dev *pbpctl_dev)
+static int bypass_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1815,7 +1816,7 @@ int bypass_on(struct bpctl_dev *pbpctl_dev)
 }
 
 /* BYPASS_OFF (0x8 111)*/
-int bypass_off(struct bpctl_dev *pbpctl_dev)
+static int bypass_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1838,7 +1839,7 @@ int bypass_off(struct bpctl_dev *pbpctl_dev)
 }
 
 /* TAP_OFF (0x9)*/
-int tap_off(struct bpctl_dev *pbpctl_dev)
+static int tap_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
@@ -1851,7 +1852,7 @@ int tap_off(struct bpctl_dev *pbpctl_dev)
 }
 
 /* TAP_ON (0xb)*/
-int tap_on(struct bpctl_dev *pbpctl_dev)
+static int tap_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
@@ -1864,7 +1865,7 @@ int tap_on(struct bpctl_dev *pbpctl_dev)
 }
 
 /* DISC_OFF (0x9)*/
-int disc_off(struct bpctl_dev *pbpctl_dev)
+static int disc_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
@@ -1876,7 +1877,7 @@ int disc_off(struct bpctl_dev *pbpctl_dev)
 }
 
 /* DISC_ON (0xb)*/
-int disc_on(struct bpctl_dev *pbpctl_dev)
+static int disc_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
@@ -1887,58 +1888,8 @@ int disc_on(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-/* DISC_PORT_ON */
-int disc_port_on(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	struct bpctl_dev *pbpctl_dev_m;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1)
-			write_data(pbpctl_dev_m, TX_DISA);
-		else
-			write_data(pbpctl_dev_m, TX_DISB);
-
-		msec_delay_bp(LATCH_DELAY);
-
-	}
-	return ret;
-}
-
-/* DISC_PORT_OFF */
-int disc_port_off(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	struct bpctl_dev *pbpctl_dev_m;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1)
-			write_data(pbpctl_dev_m, TX_ENA);
-		else
-			write_data(pbpctl_dev_m, TX_ENB);
-
-		msec_delay_bp(LATCH_DELAY);
-
-	}
-	return ret;
-}
-
 /*TWO_PORT_LINK_HW_EN (0xe)*/
-int tpl_hw_on(struct bpctl_dev *pbpctl_dev)
+static int tpl_hw_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -1966,7 +1917,7 @@ int tpl_hw_on(struct bpctl_dev *pbpctl_dev)
 }
 
 /*TWO_PORT_LINK_HW_DIS (0xc)*/
-int tpl_hw_off(struct bpctl_dev *pbpctl_dev)
+static int tpl_hw_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -1992,7 +1943,7 @@ int tpl_hw_off(struct bpctl_dev *pbpctl_dev)
 }
 
 /* WDT_OFF (0x6 110)*/
-int wdt_off(struct bpctl_dev *pbpctl_dev)
+static int wdt_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -2015,7 +1966,7 @@ int wdt_off(struct bpctl_dev *pbpctl_dev)
 static unsigned int
     wdt_val_array[] = { 1000, 1500, 2000, 3000, 4000, 8000, 16000, 32000, 0 };
 
-int wdt_on(struct bpctl_dev *pbpctl_dev, unsigned int timeout)
+static int wdt_on(struct bpctl_dev *pbpctl_dev, unsigned int timeout)
 {
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -2067,7 +2018,7 @@ int wdt_on(struct bpctl_dev *pbpctl_dev, unsigned int timeout)
 	return BP_NOT_CAP;
 }
 
-void bp75_put_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
+static void bp75_put_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 {
 	u32 swsm;
 
@@ -2078,7 +2029,7 @@ void bp75_put_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 	BPCTL_WRITE_REG(pbpctl_dev, SWSM, swsm);
 }
 
-s32 bp75_get_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
+static s32 bp75_get_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 {
 	u32 swsm;
 	s32 ret_val = 0;
@@ -2192,7 +2143,8 @@ static s32 bp75_acquire_phy(struct bpctl_dev *pbpctl_dev)
 	return ret_val;
 }
 
-s32 bp75_read_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data)
+static s32 bp75_read_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset,
+				  u16 *data)
 {
 	u32 i, mdic = 0;
 	s32 ret_val = 0;
@@ -2225,7 +2177,8 @@ s32 bp75_read_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data)
 	return ret_val;
 }
 
-s32 bp75_write_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset, u16 data)
+static s32 bp75_write_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset,
+				   u16 data)
 {
 	u32 i, mdic = 0;
 	s32 ret_val = 0;
@@ -2536,7 +2489,7 @@ static int set_bp_force_link(struct bpctl_dev *pbpctl_dev, int tx_state)
 }
 
 /*RESET_CONT 0x20 */
-int reset_cont(struct bpctl_dev *pbpctl_dev)
+static int reset_cont(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -2553,7 +2506,7 @@ int reset_cont(struct bpctl_dev *pbpctl_dev)
 }
 
 /*DIS_BYPASS_CAP 0x22 */
-int dis_bypass_cap(struct bpctl_dev *pbpctl_dev)
+static int dis_bypass_cap(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
@@ -2572,7 +2525,7 @@ int dis_bypass_cap(struct bpctl_dev *pbpctl_dev)
 }
 
 /*EN_BYPASS_CAP 0x24 */
-int en_bypass_cap(struct bpctl_dev *pbpctl_dev)
+static int en_bypass_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -2588,7 +2541,7 @@ int en_bypass_cap(struct bpctl_dev *pbpctl_dev)
 }
 
 /* BYPASS_STATE_PWRON 0x26*/
-int bypass_state_pwron(struct bpctl_dev *pbpctl_dev)
+static int bypass_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP) {
 		write_data(pbpctl_dev, BYPASS_STATE_PWRON);
@@ -2602,7 +2555,7 @@ int bypass_state_pwron(struct bpctl_dev *pbpctl_dev)
 }
 
 /* NORMAL_STATE_PWRON 0x28*/
-int normal_state_pwron(struct bpctl_dev *pbpctl_dev)
+static int normal_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP)
 	    || (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP)) {
@@ -2617,7 +2570,7 @@ int normal_state_pwron(struct bpctl_dev *pbpctl_dev)
 }
 
 /* BYPASS_STATE_PWROFF 0x27*/
-int bypass_state_pwroff(struct bpctl_dev *pbpctl_dev)
+static int bypass_state_pwroff(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP) {
 		write_data(pbpctl_dev, BYPASS_STATE_PWROFF);
@@ -2628,7 +2581,7 @@ int bypass_state_pwroff(struct bpctl_dev *pbpctl_dev)
 }
 
 /* NORMAL_STATE_PWROFF 0x29*/
-int normal_state_pwroff(struct bpctl_dev *pbpctl_dev)
+static int normal_state_pwroff(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP)) {
 		write_data(pbpctl_dev, NORMAL_STATE_PWROFF);
@@ -2639,7 +2592,7 @@ int normal_state_pwroff(struct bpctl_dev *pbpctl_dev)
 }
 
 /*TAP_STATE_PWRON 0x2a*/
-int tap_state_pwron(struct bpctl_dev *pbpctl_dev)
+static int tap_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		write_data(pbpctl_dev, TAP_STATE_PWRON);
@@ -2650,7 +2603,7 @@ int tap_state_pwron(struct bpctl_dev *pbpctl_dev)
 }
 
 /*DIS_TAP_CAP 0x2c*/
-int dis_tap_cap(struct bpctl_dev *pbpctl_dev)
+static int dis_tap_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_DIS_CAP) {
 		write_data(pbpctl_dev, DIS_TAP_CAP);
@@ -2661,7 +2614,7 @@ int dis_tap_cap(struct bpctl_dev *pbpctl_dev)
 }
 
 /*EN_TAP_CAP 0x2e*/
-int en_tap_cap(struct bpctl_dev *pbpctl_dev)
+static int en_tap_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_DIS_CAP) {
 		write_data(pbpctl_dev, EN_TAP_CAP);
@@ -2672,7 +2625,7 @@ int en_tap_cap(struct bpctl_dev *pbpctl_dev)
 }
 
 /*DISC_STATE_PWRON 0x2a*/
-int disc_state_pwron(struct bpctl_dev *pbpctl_dev)
+static int disc_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2685,7 +2638,7 @@ int disc_state_pwron(struct bpctl_dev *pbpctl_dev)
 }
 
 /*DIS_DISC_CAP 0x2c*/
-int dis_disc_cap(struct bpctl_dev *pbpctl_dev)
+static int dis_disc_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_DIS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2697,60 +2650,8 @@ int dis_disc_cap(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-/*DISC_STATE_PWRON 0x2a*/
-int disc_port_state_pwron(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	struct bpctl_dev *pbpctl_dev_m;
-
-	return BP_NOT_CAP;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1)
-			write_data(pbpctl_dev_m, TX_DISA_PWRUP);
-		else
-			write_data(pbpctl_dev_m, TX_DISB_PWRUP);
-
-		msec_delay_bp(LATCH_DELAY);
-
-	}
-	return ret;
-}
-
-int normal_port_state_pwron(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	struct bpctl_dev *pbpctl_dev_m;
-	return BP_NOT_CAP;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1)
-			write_data(pbpctl_dev_m, TX_ENA_PWRUP);
-		else
-			write_data(pbpctl_dev_m, TX_ENB_PWRUP);
-
-		msec_delay_bp(LATCH_DELAY);
-
-	}
-	return ret;
-}
-
 /*EN_TAP_CAP 0x2e*/
-int en_disc_cap(struct bpctl_dev *pbpctl_dev)
+static int en_disc_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_DIS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2762,7 +2663,7 @@ int en_disc_cap(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int std_nic_on(struct bpctl_dev *pbpctl_dev)
+static int std_nic_on(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & STD_NIC_CAP) {
@@ -2816,7 +2717,7 @@ int std_nic_on(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int std_nic_off(struct bpctl_dev *pbpctl_dev)
+static int std_nic_off(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & STD_NIC_CAP) {
@@ -2979,7 +2880,7 @@ static void wd_reset_timer(unsigned long param)
 }
 
 /*WAIT_AT_PWRUP 0x80   */
-int bp_wait_at_pwup_en(struct bpctl_dev *pbpctl_dev)
+static int bp_wait_at_pwup_en(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -2994,7 +2895,7 @@ int bp_wait_at_pwup_en(struct bpctl_dev *pbpctl_dev)
 }
 
 /*DIS_WAIT_AT_PWRUP       0x81 */
-int bp_wait_at_pwup_dis(struct bpctl_dev *pbpctl_dev)
+static int bp_wait_at_pwup_dis(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3011,7 +2912,7 @@ int bp_wait_at_pwup_dis(struct bpctl_dev *pbpctl_dev)
 
 /*EN_HW_RESET  0x82   */
 
-int bp_hw_reset_en(struct bpctl_dev *pbpctl_dev)
+static int bp_hw_reset_en(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3027,7 +2928,7 @@ int bp_hw_reset_en(struct bpctl_dev *pbpctl_dev)
 
 /*DIS_HW_RESET             0x83   */
 
-int bp_hw_reset_dis(struct bpctl_dev *pbpctl_dev)
+static int bp_hw_reset_dis(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3042,7 +2943,7 @@ int bp_hw_reset_dis(struct bpctl_dev *pbpctl_dev)
 }
 
 
-int wdt_exp_mode(struct bpctl_dev *pbpctl_dev, int mode)
+static int wdt_exp_mode(struct bpctl_dev *pbpctl_dev, int mode)
 {
 	uint32_t status_reg = 0, status_reg1 = 0;
 
@@ -3093,7 +2994,7 @@ int wdt_exp_mode(struct bpctl_dev *pbpctl_dev, int mode)
 	return BP_NOT_CAP;
 }
 
-int bypass_fw_ver(struct bpctl_dev *pbpctl_dev)
+static int bypass_fw_ver(struct bpctl_dev *pbpctl_dev)
 {
 	if (is_bypass_fn(pbpctl_dev))
 		return read_reg(pbpctl_dev, VER_REG_ADDR);
@@ -3101,7 +3002,7 @@ int bypass_fw_ver(struct bpctl_dev *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_sign_check(struct bpctl_dev *pbpctl_dev)
+static int bypass_sign_check(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (is_bypass_fn(pbpctl_dev))
@@ -3212,7 +3113,7 @@ static int bp_force_link_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_from_last_read(struct bpctl_dev *pbpctl_dev)
+static int bypass_from_last_read(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 	struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -3232,7 +3133,7 @@ int bypass_from_last_read(struct bpctl_dev *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_status_clear(struct bpctl_dev *pbpctl_dev)
+static int bypass_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
 
@@ -3246,7 +3147,7 @@ int bypass_status_clear(struct bpctl_dev *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_flag_status(struct bpctl_dev *pbpctl_dev)
+static int bypass_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if ((pbpctl_dev->bp_caps & BP_CAP)) {
@@ -3259,7 +3160,7 @@ int bypass_flag_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_flag_status_clear(struct bpctl_dev *pbpctl_dev)
+static int bypass_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3274,7 +3175,7 @@ int bypass_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_change_status(struct bpctl_dev *pbpctl_dev)
+static int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -3293,18 +3194,6 @@ int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int bypass_off_status(struct bpctl_dev *pbpctl_dev)
-{
-
-	if (pbpctl_dev->bp_caps & BP_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  BYPASS_OFF_MASK) == BYPASS_OFF_MASK) ? 1 : 0);
-		}
-	}
-	return BP_NOT_CAP;
-}
-
 static int bypass_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
@@ -3388,7 +3277,7 @@ static int bypass_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_status(struct bpctl_dev *pbpctl_dev)
+static int default_pwron_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3420,7 +3309,7 @@ static int default_pwroff_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
+static int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
@@ -3433,31 +3322,7 @@ int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int cmd_en_status(struct bpctl_dev *pbpctl_dev)
-{
-
-	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  CMND_EN_MASK) == CMND_EN_MASK) ? 1 : 0);
-		}
-	}
-	return BP_NOT_CAP;
-}
-
-int wdt_en_status(struct bpctl_dev *pbpctl_dev)
-{
-
-	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
-			return ((((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
-				  WDT_EN_MASK) == WDT_EN_MASK) ? 1 : 0);
-		}
-	}
-	return BP_NOT_CAP;
-}
-
-int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
+static int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	int ret = 0;
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -3483,40 +3348,7 @@ int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 	return ret;
 }
 
-int bypass_support(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-
-	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
-			ret =
-			    ((((read_reg(pbpctl_dev, PRODUCT_CAP_REG_ADDR)) &
-			       BYPASS_SUPPORT_MASK) ==
-			      BYPASS_SUPPORT_MASK) ? 1 : 0);
-		} else if (pbpctl_dev->bp_ext_ver == PXG2BPI_VER)
-			ret = 1;
-	} else
-		ret = BP_NOT_CAP;
-	return ret;
-}
-
-int tap_support(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-
-	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
-			ret =
-			    ((((read_reg(pbpctl_dev, PRODUCT_CAP_REG_ADDR)) &
-			       TAP_SUPPORT_MASK) == TAP_SUPPORT_MASK) ? 1 : 0);
-		} else if (pbpctl_dev->bp_ext_ver == PXG2BPI_VER)
-			ret = 0;
-	} else
-		ret = BP_NOT_CAP;
-	return ret;
-}
-
-int normal_support(struct bpctl_dev *pbpctl_dev)
+static int normal_support(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -3532,7 +3364,7 @@ int normal_support(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int get_bp_prod_caps(struct bpctl_dev *pbpctl_dev)
+static int get_bp_prod_caps(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & SW_CTL_CAP) &&
 	    (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER))
@@ -3541,7 +3373,7 @@ int get_bp_prod_caps(struct bpctl_dev *pbpctl_dev)
 
 }
 
-int tap_flag_status(struct bpctl_dev *pbpctl_dev)
+static int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
@@ -3553,7 +3385,7 @@ int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
+static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
@@ -3567,7 +3399,7 @@ int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tap_change_status(struct bpctl_dev *pbpctl_dev)
+static int tap_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
@@ -3584,17 +3416,7 @@ int tap_change_status(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int tap_off_status(struct bpctl_dev *pbpctl_dev)
-{
-	if (pbpctl_dev->bp_caps & TAP_CAP) {
-		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
-			return ((((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
-				  TAP_OFF_MASK) == TAP_OFF_MASK) ? 1 : 0);
-	}
-	return BP_NOT_CAP;
-}
-
-int tap_status(struct bpctl_dev *pbpctl_dev)
+static int tap_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
 
@@ -3633,7 +3455,7 @@ int tap_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_tap_status(struct bpctl_dev *pbpctl_dev)
+static int default_pwron_tap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
@@ -3644,7 +3466,7 @@ int default_pwron_tap_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_tap_cap_status(struct bpctl_dev *pbpctl_dev)
+static int dis_tap_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
@@ -3655,7 +3477,7 @@ int dis_tap_cap_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_flag_status(struct bpctl_dev *pbpctl_dev)
+static int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3667,7 +3489,7 @@ int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
+static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3681,7 +3503,7 @@ int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_change_status(struct bpctl_dev *pbpctl_dev)
+static int disc_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3692,7 +3514,7 @@ int disc_change_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_off_status(struct bpctl_dev *pbpctl_dev)
+static int disc_off_status(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
 	u32 ctrl_ext = 0;
@@ -3788,7 +3610,7 @@ static int disc_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_disc_status(struct bpctl_dev *pbpctl_dev)
+static int default_pwron_disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3799,7 +3621,7 @@ int default_pwron_disc_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_disc_cap_status(struct bpctl_dev *pbpctl_dev)
+static int dis_disc_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DIS_DISC_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3810,55 +3632,7 @@ int dis_disc_cap_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_port_status(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = BP_NOT_CAP;
-	struct bpctl_dev *pbpctl_dev_m;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1) {
-			return ((((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
-				  TX_DISA_MASK) == TX_DISA_MASK) ? 1 : 0);
-		} else
-			return ((((read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR)) &
-				  TX_DISB_MASK) == TX_DISB_MASK) ? 1 : 0);
-
-	}
-	return ret;
-}
-
-int default_pwron_disc_port_status(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = BP_NOT_CAP;
-	struct bpctl_dev *pbpctl_dev_m;
-
-	if ((is_bypass_fn(pbpctl_dev)) == 1)
-		pbpctl_dev_m = pbpctl_dev;
-	else
-		pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
-	if (pbpctl_dev_m == NULL)
-		return BP_NOT_CAP;
-
-	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1)
-			return ret;
-		/*  return((((read_reg(pbpctl_dev,STATUS_TAP_REG_ADDR)) & TX_DISA_MASK)==TX_DISA_MASK)?1:0); */
-		else
-			return ret;
-		/*   return((((read_reg(pbpctl_dev,STATUS_TAP_REG_ADDR)) & TX_DISA_MASK)==TX_DISA_MASK)?1:0); */
-
-	}
-	return ret;
-}
-
-int wdt_exp_mode_status(struct bpctl_dev *pbpctl_dev)
+static int wdt_exp_mode_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver <= PXG2BPI_VER)
@@ -3881,7 +3655,7 @@ int wdt_exp_mode_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tpl2_flag_status(struct bpctl_dev *pbpctl_dev)
+static int tpl2_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
@@ -3892,22 +3666,7 @@ int tpl2_flag_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tpl_hw_status(struct bpctl_dev *pbpctl_dev)
-{
-	struct bpctl_dev *pbpctl_dev_b = NULL;
-
-	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
-	if (!pbpctl_dev_b)
-		return BP_NOT_CAP;
-
-	if (TPL_IF_SERIES(pbpctl_dev->subdevice))
-		return (((BPCTL_READ_REG(pbpctl_dev, CTRL)) &
-			 BPCTLI_CTRL_SWDPIN0) != 0 ? 1 : 0);
-	return BP_NOT_CAP;
-}
-
-
-int bp_wait_at_pwup_status(struct bpctl_dev *pbpctl_dev)
+static int bp_wait_at_pwup_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3918,7 +3677,7 @@ int bp_wait_at_pwup_status(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bp_hw_reset_status(struct bpctl_dev *pbpctl_dev)
+static int bp_hw_reset_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3932,7 +3691,7 @@ int bp_hw_reset_status(struct bpctl_dev *pbpctl_dev)
 }
 
 
-int std_nic_status(struct bpctl_dev *pbpctl_dev)
+static int std_nic_status(struct bpctl_dev *pbpctl_dev)
 {
 	int status_val = 0;
 
@@ -3980,7 +3739,7 @@ int std_nic_status(struct bpctl_dev *pbpctl_dev)
 /******************************************************/
 /**************SW_INIT*********************************/
 /******************************************************/
-void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
+static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 {
 	u_int32_t ctrl_ext = 0;
 	struct bpctl_dev *pbpctl_dev_m = NULL;
@@ -4198,23 +3957,7 @@ void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 	}
 }
 
-int bypass_off_init(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = cmnd_on(pbpctl_dev);
-	if (ret < 0)
-		return ret;
-	if (INTEL_IF_SERIES(pbpctl_dev->subdevice))
-		return dis_bypass_cap(pbpctl_dev);
-	wdt_off(pbpctl_dev);
-	if (pbpctl_dev->bp_caps & BP_CAP)
-		bypass_off(pbpctl_dev);
-	if (pbpctl_dev->bp_caps & TAP_CAP)
-		tap_off(pbpctl_dev);
-	cmnd_off(pbpctl_dev);
-	return 0;
-}
-
-void remove_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
+static void remove_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 #ifdef BP_SELF_TEST
 	struct bpctl_dev *pbpctl_dev_sl = NULL;
@@ -4243,7 +3986,7 @@ void remove_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 
 }
 
-int init_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
+static int init_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		init_timer(&pbpctl_dev->bp_timer);
@@ -4290,7 +4033,7 @@ int bp_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 #endif
 
-int set_bypass_wd_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
+static int set_bypass_wd_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->reset_time != param) {
@@ -4309,7 +4052,7 @@ int set_bypass_wd_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 	return BP_NOT_CAP;
 }
 
-int get_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP)
 		return pbpctl_dev->reset_time;
@@ -4380,7 +4123,7 @@ int is_bypass_fn(struct bpctl_dev *pbpctl_dev)
 	return (((pbpctl_dev->func == 0) || (pbpctl_dev->func == 2)) ? 1 : 0);
 }
 
-int set_bypass_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
+static int set_bypass_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 
@@ -4398,12 +4141,12 @@ int set_bypass_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_fn(struct bpctl_dev *pbpctl_dev)
 {
 	return bypass_status(pbpctl_dev);
 }
 
-int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4411,7 +4154,7 @@ int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 	return bypass_change_status(pbpctl_dev);
 }
 
-int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
+static int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4430,7 +4173,7 @@ int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 	return ret;
 }
 
-int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
+static int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4438,7 +4181,7 @@ int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 	return dis_bypass_cap_status(pbpctl_dev);
 }
 
-int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
+static int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4457,7 +4200,7 @@ int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4465,7 +4208,7 @@ int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 	return default_pwroff_status(pbpctl_dev);
 }
 
-int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
+static int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4484,7 +4227,7 @@ int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4492,7 +4235,7 @@ int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	return default_pwron_status(pbpctl_dev);
 }
 
-int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
+static int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4514,7 +4257,7 @@ int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 	return ret;
 }
 
-int get_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int *timeout)
+static int get_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4522,7 +4265,7 @@ int get_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int *timeout)
 	return wdt_programmed(pbpctl_dev, timeout);
 }
 
-int get_wd_expire_time_fn(struct bpctl_dev *pbpctl_dev, int *time_left)
+static int get_wd_expire_time_fn(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4530,7 +4273,7 @@ int get_wd_expire_time_fn(struct bpctl_dev *pbpctl_dev, int *time_left)
 	return wdt_timer(pbpctl_dev, time_left);
 }
 
-int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
+static int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4538,7 +4281,7 @@ int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 	return wdt_timer_reload(pbpctl_dev);
 }
 
-int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
+static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int bp_status = 0;
 
@@ -4562,7 +4305,7 @@ int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 	return bp_status;
 }
 
-int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
+static int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4582,7 +4325,7 @@ int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 	return ret;
 }
 
-int get_std_nic_fn(struct bpctl_dev *pbpctl_dev)
+static int get_std_nic_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4590,7 +4333,7 @@ int get_std_nic_fn(struct bpctl_dev *pbpctl_dev)
 	return std_nic_status(pbpctl_dev);
 }
 
-int set_tap_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
+static int set_tap_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4606,7 +4349,7 @@ int set_tap_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_tap_fn(struct bpctl_dev *pbpctl_dev)
+static int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4614,7 +4357,7 @@ int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 	return tap_status(pbpctl_dev);
 }
 
-int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
+static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4632,7 +4375,7 @@ int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 	return ret;
 }
 
-int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
+static int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4644,7 +4387,7 @@ int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	return ((ret == 0) ? 1 : 0);
 }
 
-int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
+static int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4652,7 +4395,7 @@ int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 	return tap_change_status(pbpctl_dev);
 }
 
-int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
+static int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4669,7 +4412,7 @@ int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 		return BP_NOT_CAP;
 }
 
-int get_dis_tap_fn(struct bpctl_dev *pbpctl_dev)
+static int get_dis_tap_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4677,7 +4420,7 @@ int get_dis_tap_fn(struct bpctl_dev *pbpctl_dev)
 	return dis_tap_cap_status(pbpctl_dev);
 }
 
-int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
+static int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4694,7 +4437,7 @@ int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 	return BP_NOT_CAP;
 }
 
-int get_disc_fn(struct bpctl_dev *pbpctl_dev)
+static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4705,7 +4448,7 @@ int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
+static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4723,7 +4466,7 @@ int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 	return ret;
 }
 
-int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
+static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4733,7 +4476,7 @@ int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	return (ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0));
 }
 
-int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
+static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4743,7 +4486,7 @@ int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
+static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4761,7 +4504,7 @@ int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 		return BP_NOT_CAP;
 }
 
-int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
+static int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4772,55 +4515,7 @@ int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int set_disc_port_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
-{
-	int ret = BP_NOT_CAP;
-	if (!pbpctl_dev)
-		return -1;
-
-	if (!disc_mode)
-		ret = disc_port_off(pbpctl_dev);
-	else
-		ret = disc_port_on(pbpctl_dev);
-
-	return ret;
-}
-
-int get_disc_port_fn(struct bpctl_dev *pbpctl_dev)
-{
-	if (!pbpctl_dev)
-		return -1;
-
-	return disc_port_status(pbpctl_dev);
-}
-
-int set_disc_port_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
-{
-	int ret = BP_NOT_CAP;
-	if (!pbpctl_dev)
-		return -1;
-
-	if (!disc_mode)
-		ret = normal_port_state_pwron(pbpctl_dev);
-	else
-		ret = disc_port_state_pwron(pbpctl_dev);
-
-	return ret;
-}
-
-int get_disc_port_pwup_fn(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	if (!pbpctl_dev)
-		return -1;
-
-	ret = default_pwron_disc_port_status(pbpctl_dev);
-	if (ret < 0)
-		return ret;
-	return ((ret == 0) ? 1 : 0);
-}
-
-int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
+static int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4828,7 +4523,7 @@ int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
 	return wdt_exp_mode_status(pbpctl_dev);
 }
 
-int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
+static int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4836,19 +4531,7 @@ int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
 	return wdt_exp_mode(pbpctl_dev, param);
 }
 
-int reset_cont_fn(struct bpctl_dev *pbpctl_dev)
-{
-	int ret = 0;
-	if (!pbpctl_dev)
-		return -1;
-
-	ret = cmnd_on(pbpctl_dev);
-	if (ret < 0)
-		return ret;
-	return reset_cont(pbpctl_dev);
-}
-
-int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
+static int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 
 	struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -4869,7 +4552,7 @@ int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 	return set_tx(pbpctl_dev, tx_state);
 }
 
-int set_bp_force_link_fn(int dev_num, int tx_state)
+static int set_bp_force_link_fn(int dev_num, int tx_state)
 {
 	static struct bpctl_dev *bpctl_dev_curr;
 
@@ -4881,7 +4564,7 @@ int set_bp_force_link_fn(int dev_num, int tx_state)
 	return set_bp_force_link(bpctl_dev_curr, tx_state);
 }
 
-int set_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev, int param)
+static int set_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev, int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4889,7 +4572,7 @@ int set_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev, int param)
 	return set_bypass_wd_auto(pbpctl_dev, param);
 }
 
-int get_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev)
+static int get_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4916,7 +4599,7 @@ int get_bp_self_test_fn(struct bpctl_dev *pbpctl_dev)
 
 #endif
 
-int get_bypass_caps_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bypass_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4925,7 +4608,8 @@ int get_bypass_caps_fn(struct bpctl_dev *pbpctl_dev)
 
 }
 
-int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev, struct bpctl_dev **pbpctl_dev_out)
+static int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev,
+			       struct bpctl_dev **pbpctl_dev_out)
 {
 	int idx_dev = 0;
 	if (!pbpctl_dev)
@@ -4957,7 +4641,7 @@ int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev, struct bpctl_dev **pbpctl_
 		return 0;
 }
 
-int is_bypass(struct bpctl_dev *pbpctl_dev)
+static int is_bypass(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4968,7 +4652,7 @@ int is_bypass(struct bpctl_dev *pbpctl_dev)
 		return 0;
 }
 
-int get_tx_fn(struct bpctl_dev *pbpctl_dev)
+static int get_tx_fn(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
@@ -4988,7 +4672,7 @@ int get_tx_fn(struct bpctl_dev *pbpctl_dev)
 	return tx_status(pbpctl_dev);
 }
 
-int get_bp_force_link_fn(int dev_num)
+static int get_bp_force_link_fn(int dev_num)
 {
 	static struct bpctl_dev *bpctl_dev_curr;
 
@@ -5051,7 +4735,7 @@ static void bp_tpl_timer_fn(unsigned long param)
 	mod_timer(&pbpctl_dev->bp_tpl_timer, jiffies + BP_LINK_MON_DELAY * HZ);
 }
 
-void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
+static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
@@ -5069,7 +4753,7 @@ void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 	return;
 }
 
-int init_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
+static int init_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5082,7 +4766,7 @@ int init_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
+static int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5100,17 +4784,7 @@ int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 	return BP_NOT_CAP;
 }
 
-int get_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
-{
-	if (!pbpctl_dev)
-		return -1;
-	if (pbpctl_dev->bp_caps & TPL_CAP)
-		return pbpctl_dev->bp_tpl_flag;
-
-	return BP_NOT_CAP;
-}
-
-int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
+static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
 
 	struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -5140,7 +4814,7 @@ int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 	return BP_NOT_CAP;
 }
 
-int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
+static int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (!pbpctl_dev)
@@ -5154,7 +4828,7 @@ int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
+static int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5174,7 +4848,7 @@ int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -5187,7 +4861,7 @@ int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 	return ret;
 }
 
-int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
+static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5207,7 +4881,7 @@ int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
+static int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -5222,7 +4896,7 @@ int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 }
 
 
-int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
+static int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 		       char *add_param)
 {
 	if (!pbpctl_dev)
@@ -7024,12 +6698,6 @@ int set_wd_exp_mode_sd(int ifindex, int param)
 }
 EXPORT_SYMBOL(set_wd_exp_mode_sd);
 
-int reset_cont_sd(int ifindex)
-{
-	return reset_cont_fn(get_dev_idx_p(ifindex));
-
-}
-
 int set_tx_sd(int ifindex, int tx_state)
 {
 	return set_tx_fn(get_dev_idx_p(ifindex), tx_state);
-- 
1.7.9.5

